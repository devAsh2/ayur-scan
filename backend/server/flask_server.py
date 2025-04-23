import base64
import os
import pickle
from flask import Flask, request, jsonify
import numpy as np
from model import feature_extraction
import cv2
from flask_cors import CORS, cross_origin

app = Flask(__name__)
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'

with open('./models/scaler_60_curry.pkl', 'rb') as file:
    sc = pickle.load(file)

with open('./models/svm_poly_deg5_model_curry.pkl', 'rb') as file:
    model = pickle.load(file)

# Define the list of leaf class names
directory = '../Medicinal Leaf Dataset/Segmented Medicinal Leaf Images'
leaf_class_names = os.listdir(directory)


@app.route('/')
@cross_origin()
def index():
    return 'Server Running...'


@app.route('/predict', methods=['POST'])
@cross_origin()
def predict():
    image_data = request.json['image']
    image_data = base64_to_cv2(image_data)
    img = cv2.resize(image_data, (800,800))
    img = feature_extraction.preprocessing(image_data)
    feature = feature_extraction.extract_features(img)
    feature = feature.reshape(1, -1)
    scaled_feature = sc.transform(feature)
    prediction = model.predict(scaled_feature)
    predicted_class = leaf_class_names[int(prediction[0])]
    # prob = model.predict_proba(scaled_feature)
    # print(prob.tolist()[0])
    # probability = round(prob.tolist()[0][int(prediction[0])],4)
    response = {'predicted_class': predicted_class}
    return jsonify(response)


def base64_to_cv2(base64_data):
    decoded_data = base64.b64decode(base64_data)
    np_arr = np.frombuffer(decoded_data, np.uint8)
    img = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)

    return img


if __name__ == '__main__':
    app.run(host='192.168.128.214', port=5000, debug=True) # Change to your server's (our system in this case) IP address
