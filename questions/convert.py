import json
import uuid
import os

def read_files(directory):
    file_data_dict = {}

    # List all files in the directory
    files = [f for f in os.listdir(directory) if os.path.isfile(os.path.join(directory, f))]

    for filename in files:
        file_path = os.path.join(directory, filename)
        with open(file_path, 'r') as file:
            lines = file.readlines()
            file_data_dict[filename] = lines

    return file_data_dict

files = read_files('files')
order = ['Start pack', 'Wild party', 'Girls Party', 'Boys Night Out', 'Juicy Mix', 'Romantic pack', 'Dirty Pack', 'Devil\'s Party', 'Funny Max', 'Teens Party']

result = []

for pack_name in order:
    questions = files[pack_name]
    pack = {} 
    pack['name'] = pack_name
    questions_list = []
    for question in questions:
        question = question.replace('\n', '')
        question_dict = {}
        question_dict['id'] = str(uuid.uuid4())
        question_dict['fullText'] = question
        question_dict['text'] = question.replace('Never have I ever ', '')
        questions_list.append(question_dict)
    pack['questions'] = questions_list
    pack['id'] = pack_name.lower().replace(' ', '_')
    pack['imageName'] = 'pack_' + pack_name.lower().replace(' ', '_')
    result.append(pack)

with open('packs_data.json', 'w') as updated_file:
    json.dump(result, updated_file, indent=4)

exit()
