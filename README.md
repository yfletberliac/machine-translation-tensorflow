# Machine Translation using LSTM architecture for RNNs
## Personal DTU project - Translation for specialized texts

Standard recurrent neural network architectures challenged with translation tasks can only provide a limited range of context which is problematic for complex translations. I used for this project a Long Short-Term Memory architecture for Recurrent Neural Networks cells.
In the paper *machine_translation_report.pdf* I focus on: explaining the LSTM architecture for RNNs, describing the trained model and expressing some experiments.

#### The repository :
You will need to install **Bazel 0.1.4** yourself. It is needed to run TensorFlow with GPU support - but you can also directly use my public AMI (id: **ami-12281d05**). Choosing a g2.8xlarge instance seems to be a good performance/price ratio compromise. [EDIT] Now there are p2.xlarge instances that are more suitable for deep learning.

You will also need to accordingly add this in your .bashrc:
```bash
# for CUDA + TensorFlow
export CUDA_HOME=/usr/local/cuda
export CUDA_ROOT=/usr/local/cuda
export PATH=$PATH:$CUDA_ROOT/bin:$HOME/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_ROOT/lib64
```
