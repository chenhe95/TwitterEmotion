
BASE_DIR = fullfile('models');

files = dir(fullfile(BASE_DIR, '.*.mat'));
for file = files'
    load(file.name);
end
