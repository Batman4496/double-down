import os
from rembg import remove
from PIL import Image
import argparse

FRAME_MARGIN = 100
FRAME_SIZE = (768, 452)
ASSET_SCALE = 2

class FileHandler:

  files: list = []
  images: list = []
  assets: dict = {}

  def __init__(
    self,
    input: str,
    output: str = None
  ) -> None:
    self.input = input
    self.output = output if output else self.input 

  def get_files(self):
    directory = os.listdir(self.input)
    if 'raw' not in directory:
      return "No raw folder found!"
    
    files = [self.input + '/' + 'raw/' + file for file in os.listdir(self.input + '/raw')]
    self.files = [file for file in files if os.path.isfile(file) and file.split('.')[-1] in ['png', 'jpg']]
    return self

  def remove_bg(self):
    print("Removing Background!")
    if ('removed' not in os.listdir(self.output)):
      os.mkdir(self.output + '/removed')
      print(f"Directory Created: {self.output}/removed")

    for file in self.files:
      name = file.split('/')[-1]
      f = Image.open(file)
      o = remove(f)
      path = self.output + "/removed/" + name.split('.')[0] + '.png' 
      o = o.resize([int(FRAME_SIZE[0] / ASSET_SCALE), int(FRAME_SIZE[1] / ASSET_SCALE)])
      o.save(path)
      f.close()
      o.close()

      hand = name[0]
      index = name.split('-')[1]
      asset = self.assets.get(index)

      if not asset:
        self.assets[index] = {
          f"{hand}": path
        }
      else:
        asset[hand] = path

      print("Saved: " + path)

    return self

  def create_frames(self):
    for key in self.assets.keys():
      asset = self.assets[key]

      img = Image.new('RGBA', size=FRAME_SIZE)

      if asset.get('l'):
        left = Image.open(asset['l'])
        img.paste(left, [FRAME_MARGIN, img.height - left.height])
        left.close()

      if asset.get('r'):
        right = Image.open(asset['r'])
        img.paste(right, [(img.width - right.width) - FRAME_MARGIN, img.height - right.height])
        right.close()

      img.save(self.output + f'/{key}.png')
      img.close()
      print("Saved: " + self.output + f'/{key}.png')
            
  def load_assets(self):
    directory = os.listdir(self.input + '/removed')
    for file in directory:
      path = self.input + '/removed/' + file
      if not os.path.isfile(path):
        continue

      if file.split('.')[-1] not in ['png', 'jpg']:
        continue

      if file[0].split('-')[0] == 'l':
        self.left[file[1]] = path
      else:
        self.right[file[1]] = path
      

    return self


def main():
  parser = argparse.ArgumentParser("Background remover")
  parser.add_argument("--input", "--i", action="store", help="Path to asset folder. Must contain a raw folder with l{n}.png and r{n}.png files.", type=str)
  parser.add_argument("--skip-remove", "--sr", action="store_true", help="Skip Background remove process.")
  args = parser.parse_args()

  if not args.input:
    print("No input directory found! Please provide --input flag.")
    return
  

  fileHandler = FileHandler(args.input)


  fileHandler.get_files()
  if args.skip_remove:
    fileHandler.load_assets()
  else:
   fileHandler.remove_bg()
  
  fileHandler.create_frames()
  
  print("Script Ended..")

if __name__ == '__main__':
  main()