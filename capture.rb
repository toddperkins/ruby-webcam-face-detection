require "awesome_print"
require "opencv"
include OpenCV

# usage:
# ruby capture.rb image.jpg processed.jpg

# capture image from default webcam
capture = OpenCV::CvCapture.open

# warmup webcam
sleep 1

# save image
capture.query.save("image.jpg")

# close connection
capture.close

# help message
if ARGV.length < 2
  puts "Usage: ruby #{__FILE__} source dest"
  exit
end

# load cascade
data = './cascades/haarcascade_frontalface_alt.xml'
detector = CvHaarClassifierCascade::load(data)

image = CvMat.load(ARGV[0])

# loop through image regions
detector.detect_objects(image).each do |region|
  color = CvColor::Blue
  image.rectangle! region.top_left, region.bottom_right, :color => color
end

# save processed image
image.save_image(ARGV[1])

# init gui window to display
window = GUI::Window.new('Face detection')

# show image
window.show(image)

GUI::wait_key