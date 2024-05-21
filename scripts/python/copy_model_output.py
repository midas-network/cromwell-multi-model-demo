import os
import sys

target_topdir = "/midas" + sys.argv[1]
model_output_directory = sys.argv[2]
directory_to_walk = "./" + model_output_directory
output_file_types = list(sys.argv[3].strip('[').strip(']').split(','))
extensions = tuple(oft for oft in output_file_types)

output_file_listing = open(sys.argv[4], "w")
model_name = sys.argv[5]

print(model_output_directory)
print(output_file_types)
print(extensions)

for root, dirs, files in os.walk(directory_to_walk, topdown=False):
   for name in files:
      if output_file_types == ["all"] or name.endswith(extensions):
         output_file = os.path.join(root, name).strip()
         output_file_listing.write(output_file + "\n")
         output_file_dir = output_file[0:output_file.rfind('/') + 1]
         if output_file.startswith("././"):
            new_output_file = output_file.replace("././", "model_output/" + model_name + "/")
         else:
            new_output_file = output_file.replace(model_output_directory, "model_output/" + model_name)
         new_output_file_dir = new_output_file[0:new_output_file.rfind('/') + 1]
         print("copying file: " + output_file)
         print("new_output_file_dir: " + new_output_file_dir)
         print("new output file: " + new_output_file)
         os.system('mkdir -p ' + target_topdir + '/' + new_output_file_dir + ' && cp ' + output_file + ' ' + target_topdir + '/' + new_output_file)

output_file_listing.close()
