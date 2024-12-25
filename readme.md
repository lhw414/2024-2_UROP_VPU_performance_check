## How to Test

1. Move `generate_test_files.sh` and `test_script` to the `libxcoder` folder.
2. Generate test files by running `sudo ./generate_test_files.sh` (Note: This process may take a considerable amount of time).
3. Once the test files are generated, you can perform the desired tests using the shell scripts under `test_script`.

For example, if you want to generate test files and measure the performance of h264 to yuv decoding, follow these steps:

```sh
sudo ./generate_test_files.sh
cd test_script
sudo ./h264_to_yuv_test.sh
```
