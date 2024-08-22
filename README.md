设计的结果是header必然是data_out端口首先发出，并且在data_insert端数据输出后data_in必然紧跟着输出，不存在间隔，保证中间无气泡，然后对于header是因为在data_out的首部，那么对header进行处理，将data_insert中的有效数据保留，
无效数据以0的方式填充输出到data_out。同时经过检查查看仿真图可以得出burst传输无气泡、逐级反压、传输不丢数据、无重复数据等现象。这些是对于面试题理解并实现的效果。

![仿真图 2024-08-22 144534](https://github.com/user-attachments/assets/adc6334d-32ec-4d0f-beb3-0e6e1f51800e)
