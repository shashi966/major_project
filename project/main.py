import cv2
import numpy as np

image_path = '/home/shashi/Desktop/CDAC/IOT/project/path_to_image.gif'
image = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)

if image is None:
    print("Error: Image not found or unable to load.")
else:
    print("Image loaded successfully.")
    cv2.imshow('Loaded Image', image)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

    # Apply histogram equalization
    equalized_image = cv2.equalizeHist(image)

    # Save the result
    output_path = '/home/shashi/Desktop/CDAC/IOT/project/equalized_image.jpg'
    cv2.imwrite(output_path, equalized_image)
    print(f"Equalized image saved to {output_path}")
