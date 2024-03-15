#!/bin/bash
# ./getzip pptx_file folder_name
# pptx_file .pptx which 
# folder_name is the resulting folder containing extract audio

####################################################################
# Stage 1: create zip folder from .pptx file to extract embedded audio   

nargs=$# 

# Command argement check
if [[ $nargs -eq 0 || $nargs -eq 1 ]]; then
    echo "Missing pptx file and/or folder name"
    exit 1
elif [[ $nargs -gt 2 ]]; then 
    echo "Excess arguments passed through" 
    exit 2 
else
    filename=$1
    foldername=$2
fi 

if [ "${filename: -5}" != ".pptx" ]; then
    echo "First argument pass is not .pptx file"
    exit 3
fi

#cp file
echo "Making folder with pptx assets ..."
cp ./$filename ./${foldername}.zip


if [ $? -ne 0 ]; then
    echo "Execution failed"
    exit 4
fi 

unzip ${foldername}.zip -d $foldername
rm ${foldername}.zip
echo "Successfully created new folder: $foldername"

########################################################################
# Stage 2: Extracting audio files from pptx assets

audioAssetPath="${foldername}/ppt/media/"
resultAudioFolder="../../audio"
audioTEMP="../../audiofiles.txt"

# echo $audiopath 
echo "Entering AudioPath: $audioAssetPath ..."
cd ${audioAssetPath}
echo

echo "Moving these .m4a files to new audio folder: ${foldername}/${resultAudioFolder}"
ls *.m4a 
echo 
ls *.m4a > $audioTEMP #overridess exiting files 

if [ -d $resultAudioFolder ]; then
    #remove audio folder if already exits 
    rm -r $resultAudioFolder 
fi

mkdir $resultAudioFolder  #subsequently create foldername/audiofolder

for audiofile in $(cat $audioTEMP)
do 
    #copy audiofile from .pptx default path to foldername/audiofile
    cp $audiofile $resultAudioFolder/$audiofile
done 

rm $audioTEMP  #delete tempfile
cd ../../      #return to ./foldername/

#####################################################################
# Stage 3: Removing all other auxiliary folders from PPTX extraction

retainFolder="audio" 
filesTEMP="allfiles.txt"
ls > $filesTEMP

echo "Starting process to remove unnecessary files ..."
for item in $(cat $filesTEMP)
do
    if [[ -d $item && $item == $retainFolder ]]; then 
        #item is folder containing extracted audio files
    elif [[ -d $item ]]; then 
        #item is dir 
        rm -r $item
        echo "Removed directory: $item"
    else 
        #item if file 
        rm $item    
        echo "Removed file: $item"
    fi
done

echo 
echo "Successfully extracted audio from desired .pptx folder!!"
echo "Enjoy .pptx audio without the .pptx pain ever again :D"
exit 0