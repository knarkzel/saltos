// Create reference to the VGA buffer that is 80x25
const vga = blk: {
    const size = 80 * 25;
    const ptr: [*]volatile u16 = @ptrFromInt(0xB8000);
    break :blk ptr[0..size];
};

pub fn main() void {
    // Clear screen
    for (vga) |*cell| cell.* = 0;

    // Draw text to screen
    const color = 0x0A;
    for ("saltos>", 0..) |letter, i| {
        vga[i] = color << 8 | @as(u16, letter);
    }
}
