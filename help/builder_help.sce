// SSCT GPL v3

here = get_absolute_file_path("builder_help.sce");
d = dir(here);
d = d.name(d.isdir);
la_LA = d(grep(d, "/[a-z]{2}_[A-Z]{2}/", "r"));  // filtering out ./images/ ./mml/, ...
tbx_builder_help_lang(la_LA, here);
clear here d la_LA
