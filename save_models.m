function save_models(file_name, models)

BASE_DIR = fullfile('models');
BACKUP_DIR = fullfile('models', 'backup');

file_name = [file_name '.mat'];

file_path = fullfile(BASE_DIR, file_name);

if exist(file_path, file_name)
    index = 0;
    backup_path = fullfile(BACKUP_DIR, [file_name num2str(index)]);
    while exist(backup_path, 'file')
        index = index + 1;
        backup_path = fullfile(BACKUP_DIR, [file_name num2str(index)]);
    end
    movefile(file_path, backup_path);
end

save(file_path, 'models');

end