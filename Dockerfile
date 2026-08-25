# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.8.4-base

# All models this workflow needs are hosted in public (ungated) HuggingFace
# repos, so no HF token is required for any of these downloads.

# download models into comfyui
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do comfy model download --url 'https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn.safetensors' --relative-path models/text_encoders --filename 't5xxl_fp8_e4m3fn.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do comfy model download --url 'https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors' --relative-path models/text_encoders --filename 'clip_l.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
# flux1-dev.safetensors is mirrored publicly (ungated) by Comfy-Org
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do comfy model download --url 'https://huggingface.co/Comfy-Org/flux1-dev/resolve/main/flux1-dev.safetensors' --relative-path models/diffusion_models --filename 'flux1-dev.sft' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
# ae.sft (VAE) is mirrored publicly (ungated) by camenduru
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do comfy model download --url 'https://huggingface.co/camenduru/FLUX.1-dev/resolve/main/ae.sft' --relative-path models/vae --filename 'ae.sft' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do comfy model download --url 'https://huggingface.co/buckets/natastia/custom/resolve/allerted-f2d_000002500.safetensors' --relative-path models/loras --filename 'allerted-f2d_000002500.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do comfy model download --url 'https://huggingface.co/buckets/natastia/custom/resolve/abdl.safetensors' --relative-path models/loras --filename 'abdl.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do comfy model download --url 'https://huggingface.co/buckets/natastia/custom/resolve/paloma_000002000.safetensors' --relative-path models/loras --filename 'paloma_000002000.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done

# Sanity check: fail the build loudly if any download silently produced a
# missing/empty file (comfy-cli has been observed to exit 0 without saving a
# file when auth fails on a gated URL, instead of a nonzero exit code).
RUN for f in \
      /comfyui/models/text_encoders/t5xxl_fp8_e4m3fn.safetensors \
      /comfyui/models/text_encoders/clip_l.safetensors \
      /comfyui/models/diffusion_models/flux1-dev.sft \
      /comfyui/models/vae/ae.sft \
      /comfyui/models/loras/allerted-f2d_000002500.safetensors \
    ; do \
      if [ ! -s "$f" ]; then echo "ERROR: expected model file missing or empty: $f" >&2; exit 1; fi; \
    done
