#!/bin/bash
allFiles=$(find . -name '*.jpg' -print)
#splitIntoArray=${$allFiles[@]}

compressedFolder="/home/wrostom/eshtri-compressed"
mkdir -p $compressedFolder
#echo $allFiles
for i in $allFiles; do
	basenameFile=$(echo $i | cut -c3-)
	basenameFileExt="${basenameFile##*.}"
	basenameFileWoutExt="${basenameFile%.*}"
	basenameDir=$(echo $(dirname $i) | cut -c3-)
	imageWidth=$(identify -ping -format "%w" $i)
	imageHeight=$(identify -ping -format "%h" $i)
	targetDir=$compressedFolder/$basenameDir
	$(mkdir -p $targetDir)
	$(convert -resize 1% $i $compressedFolder/$basenameFileWoutExt-42.$basenameFileExt)
	if [ $imageWidth -gt $imageHeight ]; then
		echo "landscape"
		$(convert -resize 75% $i $compressedFolder/$basenameFile)
		$(convert -geometry 625x $i $compressedFolder/$basenameFileWoutExt-500.$basenameFileExt)
		$(squoosh-cli --mozjpeg '{"quality":85,"baseline":true,"arithmetic":false,"progressive":true,"optimize_coding":true,"smoothing":0,"color_space":3,"quant_table":3,"trellis_multipass":true,"trellis_opt_zero":false,"trellis_opt_table":false,"trellis_loops":12,"auto_subsample":false,"chroma_subsample":1,"separate_chroma_quality":true,"chroma_quality":70}' -d $targetDir --suffix "-large" --optimizer-butteraugli-target 1 $compressedFolder/$basenameFile)
		$(squoosh-cli --mozjpeg '{"quality":80,"baseline":false,"arithmetic":false,"progressive":true,"optimize_coding":true,"smoothing":0,"color_space":3,"quant_table":3,"trellis_multipass":true,"trellis_opt_zero":false,"trellis_opt_table":false,"trellis_loops":7,"auto_subsample":false,"chroma_subsample":1,"separate_chroma_quality":true,"chroma_quality":65}' -d $targetDir --optimizer-butteraugli-target 2 $compressedFolder/$basenameFileWoutExt-500.$basenameFileExt)
		$(squoosh-cli --mozjpeg --mozjpeg '{"quality":70,"baseline":false,"arithmetic":false,"progressive":true,"optimize_coding":true,"smoothing":29,"color_space":3,"quant_table":3,"trellis_multipass":true,"trellis_opt_zero":false,"trellis_opt_table":false,"trellis_loops":7,"auto_subsample":false,"chroma_subsample":1,"separate_chroma_quality":true,"chroma_quality":65}' -d $targetDir --optimizer-butteraugli-target 2 $compressedFolder/$basenameFileWoutExt-42.$basenameFileExt)
		$(squoosh-cli --webp '{"quality":80,"target_size":0,"target_PSNR":0,"method":4,"sns_strength":50,"filter_strength":60,"filter_sharpness":0,"filter_type":1,"partitions":0,"segments":4,"pass":1,"show_compressed":0,"preprocessing":0,"autofilter":0,"partition_limit":0,"alpha_compression":1,"alpha_filtering":1,"alpha_quality":100,"lossless":0,"exact":0,"image_hint":0,"emulate_jpeg_size":0,"thread_level":0,"low_memory":0,"near_lossless":100,"use_delta_palette":0,"use_sharp_yuv":0}' -d $targetDir --optimizer-butteraugli-target 1 $compressedFolder/$basenameFile)
	else
		echo "portrait"
		$(convert -resize 33.3% $i $compressedFolder/$basenameFile)
		$(convert -geometry x625 $i $compressedFolder/$basenameFileWoutExt-500.$basenameFileExt)
		# Compressing the main image to JPEG
		$(squoosh-cli --mozjpeg '{"quality":85,"baseline":true,"arithmetic":false,"progressive":true,"optimize_coding":true,"smoothing":0,"color_space":3,"quant_table":3,"trellis_multipass":true,"trellis_opt_zero":false,"trellis_opt_table":false,"trellis_loops":12,"auto_subsample":false,"chroma_subsample":1,"separate_chroma_quality":true,"chroma_quality":70}' -d $targetDir --suffix "-large" --optimizer-butteraugli-target 2 $compressedFolder/$basenameFile)
		# Compressing the 500 image
		$(squoosh-cli --mozjpeg '{"quality":80,"baseline":false,"arithmetic":false,"progressive":true,"optimize_coding":true,"smoothing":0,"color_space":3,"quant_table":3,"trellis_multipass":true,"trellis_opt_zero":false,"trellis_opt_table":false,"trellis_loops":7,"auto_subsample":false,"chroma_subsample":1,"separate_chroma_quality":true,"chroma_quality":65}' -d $targetDir --optimizer-butteraugli-target 2 $compressedFolder/$basenameFileWoutExt-500.$basenameFileExt)
		# Compressing the 42 image
		$(squoosh-cli --mozjpeg --mozjpeg '{"quality":70,"baseline":false,"arithmetic":false,"progressive":true,"optimize_coding":true,"smoothing":29,"color_space":3,"quant_table":3,"trellis_multipass":true,"trellis_opt_zero":false,"trellis_opt_table":false,"trellis_loops":7,"auto_subsample":false,"chroma_subsample":1,"separate_chroma_quality":true,"chroma_quality":65}' -d $targetDir --optimizer-butteraugli-target 2 $compressedFolder/$basenameFileWoutExt-42.$basenameFileExt)
		# Compressing the main image to WEBP
		$(squoosh-cli --webp '{"quality":80,"target_size":0,"target_PSNR":0,"method":4,"sns_strength":50,"filter_strength":60,"filter_sharpness":0,"filter_type":1,"partitions":0,"segments":4,"pass":1,"show_compressed":0,"preprocessing":0,"autofilter":0,"partition_limit":0,"alpha_compression":1,"alpha_filtering":1,"alpha_quality":100,"lossless":0,"exact":0,"image_hint":0,"emulate_jpeg_size":0,"thread_level":0,"low_memory":0,"near_lossless":100,"use_delta_palette":0,"use_sharp_yuv":0}' -d $targetDir --optimizer-butteraugli-target 2 $compressedFolder/$basenameFile)
	fi
	$(mv $compressedFolder/$basenameFileWoutExt-large.$basenameFileExt $compressedFolder/$basenameFile)
done
