from flask import Flask
from flask import request
from colorthief import ColorThief
from scipy.spatial import KDTree
from webcolors import hex_to_rgb
from colors import colors_dict
from googletrans import Translator

# https://medium.com/codex/rgb-to-color-names-in-python-the-robust-way-ec4a9d97a01f
def convert_rgb_to_names(rgb_tuple): 
    css3_db = colors_dict
    
    names = []
    rgb_values = []    
    for color_hex, color_name in css3_db.items():
        names.append(color_name)
        rgb_values.append(hex_to_rgb("#" + color_hex))
    
    kdt_db = KDTree(rgb_values)    
    distance, index = kdt_db.query(rgb_tuple)
    print(distance)
    return [names[index], Translator().translate(names[index], dest='sk').text]
    #return names[index]


app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"


@app.route('/upload', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        f = request.files['the_file']
        print(type(f))
        color_thief = ColorThief(f)
        dominant_color = color_thief.get_color(quality=1)
        print(dominant_color)
        colors = convert_rgb_to_names(dominant_color)
        return f"<p>Slovensky: {colors[1]}</p><p>Anglicky: {colors[0]}</p>"
