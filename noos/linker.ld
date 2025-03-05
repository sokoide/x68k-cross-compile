ENTRY(boot)

MEMORY
{
	RAM (rwx) : ORIGIN = 0x00002000, LENGTH = 1K
}

SECTIONS
{
	_start = .;

	.text : {
		__text_start = .;
		*(.text)
		*(.rela.text)
		*(.rodata)
		__text_end = .;
	} > RAM
	__test_size = __text_end - __text_start;

	.data : {
		__data_start = .;
		*(.data)
		__data_end = .;
	} > RAM
	__data_size = __data_end - __data_end;

	.bss : {
		__data_start = .;
		*(.bss)
		*(COMMON)
		__data_end = .;
	} > RAM
	__data_size = __data_end - __data_end;
}
