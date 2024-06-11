from PIL import Image

img_raw = Image.open("./BirdDown.png")

#预处理
# 获取图片尺寸的大小__预期(600,400)
print (img_raw.size)
# 获取图片的格式 png
print (img_raw.format)
# 获取图片的图像类型 RGBA
print (img_raw.mode)
# 生成缩略图
img_raw.thumbnail((92, 80))
# 把图片强制转成RGB
img = img_raw.convert("RGBA")
# 把图片调整为16色
img_w=img.size[0]
img_h=img.size[1]
for i in range(0,img_w):
 for j in range(0,img_h):
  data=img.getpixel((i,j))
  re=(16*int(data[0]/16),16*int(data[1]/16),16*int(data[2]/16),16*int(data[3]/16))
  img.putpixel((i,j),re)
# 保存图片
img.save('./image_thumb.png', 'PNG')
# 显示图片
# img.show()

# 转换为.coe文件
width=92
height=80
file = open("./BirdDown.coe","w")
file.write(";7360\nmemory_initialization_radix=16;\nmemory_initialization_vector=\n")
for j in range(0,height):
 for i in range(0,width):
  data=img.getpixel((i, j))
  re=['%01X' %int(s/16) for s in data]
  result=""
  for item in re:
    result+=item
  file.write(result)
  file.write(" ")
 file.write("\n")
for i in range(0,7360-width*height):
 file.write("0000 ")
file.write("\n;")
print("Finish")
