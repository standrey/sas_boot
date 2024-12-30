void kernel_entry_point() {
    char* vram_memory = (char*) 0xb8000;
    *vram_memory = 'X';
}
