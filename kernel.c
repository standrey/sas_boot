void print_symbol(char c) {
    char* vram_memory = (char*) 0xb8000;
    *vram_memory = c;
}

void kernel_entry_point() {
    print_symbol('Q');
}
