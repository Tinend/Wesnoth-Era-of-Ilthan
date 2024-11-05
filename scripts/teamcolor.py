from PIL import Image
import numpy as np
import os

def extract_team_colors(color_image_path):
    """Extract unique non-black colors from an image."""
    # Open the image and convert it to RGB
    img = Image.open(color_image_path).convert("RGB")
    img_data = np.array(img)

    # Get unique colors in the image, excluding pure black
    unique_colors = set(tuple(pixel) for row in img_data for pixel in row if tuple(pixel) != (0, 0, 0))

    # Convert the set to a list for easier use in later code
    team_colors = list(unique_colors)

    # Print and return the list of team colors
    print("Extracted team colors:", team_colors)
    return team_colors

def is_close_color(rgb, target_rgb, tolerance):
    """Check if an RGB color is within a specified tolerance of a target RGB color, but not an exact match."""
    return sum((c1 - c2) ** 2 for c1, c2 in zip(rgb, target_rgb)) <= tolerance ** 2

def is_near_team_color(pixel_rgb, team_colors, tolerance):
    """Check if an RGB color is within a specified tolerance of one of the team colors, but not an exact match."""
    # Ignore black pixels because there are a lot of them and they are near a team color.
    if is_close_color(pixel_rgb, (0, 0, 0), tolerance):
        return False

    # Skip exact matches.
    for team_rgb in team_colors:
        if pixel_rgb == team_rgb:
            return False

    # Check each target team color for near matches
    for team_rgb in team_colors:
        if is_close_color(pixel_rgb, team_rgb, tolerance):
            return True

    return False

def find_near_team_colors(image_path, team_colors, tolerance):
    """Identify pixels in the image that are close to team colors but not an exact match."""
    # Open the image and convert to RGB if not already in RGB mode
    img = Image.open(image_path).convert("RGB")
    img_data = np.array(img)
    
    # Track coordinates of close but non-matching colors
    close_color_coords = []
    
    # Scan each pixel in the image
    for y in range(img_data.shape[0]):
        for x in range(img_data.shape[1]):
            pixel_rgb = tuple(img_data[y, x][:3])
            if is_near_team_color(pixel_rgb, team_colors, tolerance):
                close_color_coords.append((x, y, pixel_rgb))

    # Output results
    if close_color_coords:
        print(f"Found {len(close_color_coords)} pixels close to team colors in '{image_path}':")
        for coord in close_color_coords:
            x, y, color = coord
            print(f" - Pixel at ({x}, {y}) has RGB {color}, close to a team color.")
    else:
        print(f"No near-team colors found in '{image_path}'.")

def process_directory_recursively(directory, team_colors, tolerance):
    """Call find_near_team_colors for every PNG image in the given directory and all subdirectories."""
    for root, _, files in os.walk(directory):
        for filename in files:
            if filename.lower().endswith(".png"):
                image_path = os.path.join(root, filename)
                find_near_team_colors(image_path, team_colors, tolerance)

team_colors = extract_team_colors("images/colorswatch_200.png")

# Set a threshold for "closeness" to the team colors (e.g., color difference tolerance)
color_tolerance = 5  # Increase or decrease as needed

process_directory_recursively("images/units", team_colors, color_tolerance)
