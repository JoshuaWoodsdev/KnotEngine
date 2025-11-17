
return {
   source dir = {
    "states",
    "entities",
    "systems"
    "."
   },
   
   --compiled files go her root
   output_dir = ".",


   --folder not to be complied
   skip_dir = {
     "lib",
     "maps",
     "assets"
   },

   --enforce types
   strict = true,


}