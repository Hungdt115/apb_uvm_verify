# Bối cảnh dự án Gemini: Môi trường UVM APB

## Tổng quan dự án

Dự án này là một môi trường kiểm thử (testbench) dựa trên UVM (Universal Verification Methodology) để xác minh một thiết bị slave APB (Advanced Peripheral Bus). Môi trường được cấu trúc để kiểm tra chức năng, khả năng xử lý lỗi và hiệu suất của thiết kế slave APB.

## Công nghệ sử dụng

*   **Ngôn ngữ mô tả phần cứng:** Verilog, SystemVerilog
*   **Phương pháp xác minh:** UVM (Universal Verification Methodology)

## Cấu trúc thư mục

*   **/src**: Chứa mã nguồn cho Thiết kế đang được kiểm tra (Design Under Test - DUT).
    *   `apb_dut.v`: Tệp Verilog mô tả logic của slave APB.
    *   `apb_if.sv`: Giao diện SystemVerilog cho bus APB.

*   **/env**: Chứa các thành phần cốt lõi của môi trường kiểm thử UVM.
    *   `apb_env.sv`: Lớp môi trường cấp cao nhất, bao bọc tất cả các thành phần UVM khác.
    *   `apb_transaction.sv`: Định nghĩa gói giao dịch (transaction packet) của APB.
    *   `apb_wagent.sv` / `apb_ragent.sv`: Agent ghi và đọc, chứa sequencer, driver và monitor cho các hoạt động tương ứng.
    *   `apb_wdriver.sv`: Driver cho agent ghi.
    *   `apb_rmonitor.sv` / `apb_wmonitor.sv`: Monitor cho agent đọc và ghi.
    *   `apb_sequencer.sv`: Sequencer trung tâm điều khiển luồng giao dịch.
    *   `apb_scoreboard.sv`: Scoreboard để kiểm tra tính đúng đắn của hành vi DUT.
    *   `apb_coverage_model.sv`: Chứa các định nghĩa về độ bao phủ chức năng (functional coverage).

*   **/test**: Chứa các bài kiểm tra (test) và chuỗi (sequence) UVM.
    *   `apb_base_test.sv`: Lớp test cơ sở mà tất cả các test khác kế thừa. Nó xử lý các giai đoạn build và connect của môi trường.
    *   `sequences/`: Thư mục này chứa các chuỗi UVM khác nhau tạo ra các mẫu kích thích cụ thể để kiểm tra các tính năng khác nhau của DUT.

*   **/sim**: Dành cho các kịch bản mô phỏng (ví dụ: Makefiles, run scripts cho các trình mô phỏng như VCS, Questa, Xcelium).

*   **/log**: Thư mục mặc định để lưu trữ nhật ký mô phỏng và tệp sóng (waveform dump).

*   `apb_top.sv`: Tệp SystemVerilog cấp cao nhất, khởi tạo DUT (`apb_dut.v`) và môi trường kiểm thử (`apb_if.sv`, `apb_base_test.sv`).

## Luồng làm việc và các tệp chính

1.  **DUT**: `src/apb_dut.v`
2.  **UVM Environment Top**: `env/apb_env.sv`
3.  **Test Top**: `test/apb_base_test.sv`
4.  **Simulation Top**: `apb_top.sv`

Một luồng làm việc điển hình sẽ là:
1.  Một bài test (ví dụ, kế thừa từ `apb_base_test`) được chọn.
2.  Mô phỏng được khởi chạy bằng một kịch bản từ thư mục `sim/`.
3.  Bài test bắt đầu một chuỗi từ thư mục `test/sequences/` trên `apb_sequencer`.
4.  Chuỗi tạo ra các giao dịch được gửi đến DUT thông qua driver.
5.  Monitor ghi lại lưu lượng trên bus, và scoreboard (`apb_scoreboard`) xác minh dữ liệu.
6.  Nhật ký được tạo ra trong thư mục `log/`.

## Quy ước đặt tên

*   Các thành phần có tiền tố `apb_`.
*   Tên tệp và lớp sử dụng kiểu `snake_case` (ví dụ: `apb_write_read_sequence`).