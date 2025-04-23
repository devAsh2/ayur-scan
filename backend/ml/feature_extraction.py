import cv2
import numpy as np
import pandas as pd
from skimage.feature import graycomatrix, graycoprops
from scipy.stats import skew, kurtosis

def preprocessing(img):
    # convert to grayscale
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # apply binary thresholding to get black and white image
    _, thresh = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY_INV+cv2.THRESH_OTSU)

    # find contours in the binary image
    contours, hierarchy = cv2.findContours(thresh, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

    # find the contour with the largest area
    largest_contour = max(contours, key=cv2.contourArea)

    # Get the bounding box around the largest contour
    x, y, w, h = cv2.boundingRect(largest_contour)

    # Crop the image using the bounding box
    crop = img[y:y+h, x:x+w]
    
    return crop

def get_glcm_features(img):
    properties = ['contrast', 'dissimilarity', 'homogeneity', 'energy', 'correlation']
    # Convert to HSV
    hsv_img = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)

    # Extract green, hue, saturation, and value channels
    g_channel = img[:,:,1]
    h_channel = hsv_img[:,:,0]
    s_channel = hsv_img[:,:,1]

    # Calculate GLCM for each channel
    glcm_g = graycomatrix(g_channel, [1], [0, np.pi/4, np.pi/2, 3*np.pi/4], symmetric=True, normed=True)
    glcm_h = graycomatrix(h_channel, [1], [0, np.pi/4, np.pi/2, 3*np.pi/4], symmetric=True, normed=True)
    glcm_s = graycomatrix(s_channel, [1], [0, np.pi/4, np.pi/2, 3*np.pi/4], symmetric=True, normed=True)

    # Calculate GLCM properties for each channel
    feats_g = [graycoprops(glcm_g, prop).ravel()[0] for prop in properties]
    feats_h = [graycoprops(glcm_h, prop).ravel()[0] for prop in properties]
    feats_s = [graycoprops(glcm_s, prop).ravel()[0] for prop in properties]

    return np.hstack([feats_g, feats_h, feats_s])


def get_geometric_features(img):
    gray_crop = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    ret_crop, thresh_crop = cv2.threshold(gray_crop, 0, 255, cv2.THRESH_BINARY_INV+cv2.THRESH_OTSU)
    contours_crop, hierarchy_crop = cv2.findContours(thresh_crop, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
    largest_contour_crop = max(contours_crop, key=cv2.contourArea)
    ellipse = cv2.fitEllipse(largest_contour_crop)
    major_axis = max(ellipse[1])
    minor_axis = min(ellipse[1])
    convex_hull = cv2.convexHull(largest_contour_crop)
    leaf_area = cv2.contourArea(largest_contour_crop)
    leaf_perimeter = cv2.arcLength(largest_contour_crop, True)
    convex_hull_area = cv2.contourArea(convex_hull)
    convex_hull_perimeter = cv2.arcLength(convex_hull, True)
    convex_hull_ratio = leaf_area / convex_hull_area
    return [major_axis, minor_axis, major_axis/minor_axis, convex_hull_area, convex_hull_perimeter, convex_hull_ratio]

def get_hsv_features(img):
    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)

    # Split HSV channels
    h, s, v = cv2.split(hsv)

    # Calculate the mean, standard deviation, skewness, and kurtosis of each channel
    h_mean = np.mean(h)
    s_mean = np.mean(s)
    v_mean = np.mean(v)
    h_std = np.std(h)
    s_std = np.std(s)
    v_std = np.std(v)
    h_skew = skew(h.flatten())
    s_skew = skew(s.flatten())
    v_skew = skew(v.flatten())
    h_kurtosis = kurtosis(h.flatten())
    s_kurtosis = kurtosis(s.flatten())
    v_kurtosis = kurtosis(v.flatten())

    return [h_mean, h_std, h_skew, h_kurtosis, s_mean, s_std, s_skew, s_kurtosis, v_mean, v_std, v_skew, v_kurtosis]

def get_rgb_features(img):
    # Split RGB channels
    r, g, b = cv2.split(img)

    # Calculate the mean, standard deviation, skewness, and kurtosis of each channel
    r_mean = np.mean(r)
    g_mean = np.mean(g)
    b_mean = np.mean(b)
    r_std = np.std(r)
    g_std = np.std(g)
    b_std = np.std(b)
    r_skew = skew(r.flatten())
    g_skew = skew(g.flatten())
    b_skew = skew(b.flatten())
    r_kurtosis = kurtosis(r.flatten())
    g_kurtosis = kurtosis(g.flatten())
    b_kurtosis = kurtosis(b.flatten())

    return [r_mean, r_std, r_skew, r_kurtosis, g_mean, g_std, g_skew, g_kurtosis, b_mean, b_std, b_skew, b_kurtosis]

def extract_features(img, label):
    fv_rgb = get_rgb_features(img)
    fv_hsv = get_hsv_features(img)
    fv_geometric = get_geometric_features(img)
    fv_glcm = get_glcm_features(img)
    feature = np.hstack([fv_rgb, fv_hsv, fv_geometric, fv_glcm, label])
    return feature