#bin/bash
# Script to setup and configure a Llama-GPT.sh Docker container and start it

source ~/RRHQD/Core/Core.sh

cd $ROOT_FOLDER

git clone https://github.com/getumbrel/llama-gpt.git

cd $ROOT_FOLDER/$LLAMA_GPT_FOLDER

./run.sh --model 7b