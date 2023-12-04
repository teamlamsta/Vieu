import os
import argparse
import cv2
import numpy as np
import sys
import glob
import importlib.util
from tflite_runtime.interpreter import Interpreter
import timeit

image_path = 'images'
#GRAPH_NAME = '/home/raspi/Desktop/forus/tflite/ssd_mobilenet_v2_320x320_coco17_tpu-8/detect_quant.tflite'
GRAPH_NAME = 'model.tflite'
#GRAPH_NAME = 'model.tflite'
LABELMAP_NAME = 'labels.txt'
min_conf_threshold = 0.5

model_loadtime_start = timeit.default_timer()
with open(LABELMAP_NAME, 'r') as f:
    labels = [line.strip() for line in f.readlines()]
    
interpreter = Interpreter(model_path=GRAPH_NAME)
interpreter.allocate_tensors()

# Get model details
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()
height = input_details[0]['shape'][1]
width = input_details[0]['shape'][2]

floating_model = (input_details[0]['dtype'] == np.float32)

input_mean = 127.5
input_std = 127.5

outname = output_details[0]['name']
if ('StatefulPartitionedCall' in outname): # This is a TF2 model
    boxes_idx, classes_idx, scores_idx = 1, 3, 0
else: # This is a TF1 model
    boxes_idx, classes_idx, scores_idx = 0, 1, 2

print('model load time is ', timeit.default_timer()-model_loadtime_start)

for i in os.listdir(image_path):
    print(i)
    model_infer_start = timeit.default_timer()
    image = cv2.imread(os.path.join(image_path, i))
    image_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    imH, imW, _ = image.shape
    image_area = imH*imW
    print("image size is : ",imH,'x',imW)
    image_resized = cv2.resize(image_rgb, (width, height))
    input_data = np.expand_dims(image_resized, axis=0)

    # Normalize pixel values if using a floating model (i.e. if model is non-quantized)
    if floating_model:
        input_data = (np.float32(input_data) - input_mean) / input_std

    # Perform the actual detection by running the model with the image as input
    interpreter.set_tensor(input_details[0]['index'],input_data)
    interpreter.invoke()

    # Retrieve detection results
    boxes = interpreter.get_tensor(output_details[boxes_idx]['index'])[0] # Bounding box coordinates of detected objects
    classes = interpreter.get_tensor(output_details[classes_idx]['index'])[0] # Class index of detected objects
    scores = interpreter.get_tensor(output_details[scores_idx]['index'])[0] # Confidence of detected objects

    detections = []
    iris_area = 0
    pupil_detected = False
    # Loop over all detections and draw detection box if confidence is above minimum threshold
    for i in range(len(scores)):
        if ((scores[i] > min_conf_threshold) and (scores[i] <= 1.0)):

            # Get bounding box coordinates and draw box
            # Interpreter can return coordinates that are outside of image dimensions, need to force them to be within image using max() and min()
            ymin = int(max(1,(boxes[i][0] * imH)))
            xmin = int(max(1,(boxes[i][1] * imW)))
            ymax = int(min(imH,(boxes[i][2] * imH)))
            xmax = int(min(imW,(boxes[i][3] * imW)))
            
            cv2.rectangle(image, (xmin,ymin), (xmax,ymax), (10, 255, 0), 2)
            # Draw label
            object_name = labels[int(classes[i])] # Look up object name from "labels" array using class index
            if object_name == 'Iris':
                iris_area = (xmax-xmin)*(ymax-ymin)
            if object_name == 'Pupil':
                pupil_detected = True
            label = '%s: %d%%' % (object_name, int(scores[i]*100)) # Example: 'person: 72%'
            labelSize, baseLine = cv2.getTextSize(label, cv2.FONT_HERSHEY_SIMPLEX, 0.7, 2) # Get font size
            label_ymin = max(ymin, labelSize[1] + 10) # Make sure not to draw label too close to top of window
            cv2.rectangle(image, (xmin, label_ymin-labelSize[1]-10), (xmin+labelSize[0], label_ymin+baseLine-10), (255, 255, 255), cv2.FILLED) # Draw white box to put label text in
            cv2.putText(image, label, (xmin, label_ymin-7), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 0), 2) # Draw label text

            detections.append([object_name, scores[i], xmin, ymin, xmax, ymax])

    print('model inference done ', timeit.default_timer() - model_infer_start)
    print("Iris area: ",iris_area)
    if iris_area/image_area > 0.09 and pupil_detected:
        print("capture the image")
    else:
        print("no eye found")

    cv2.imshow('Object detector', image)
    cv2.waitKey(0)

