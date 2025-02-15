# Đa ngôn ngữ (multi languague) trong Qt Quick 6.8+
1. Chạy câu lệnh để tạo file `.ts`
```
lupdate F:\dao-tao\ngon-ngu-lap-trinh\learning.nentang.vn-c-plus-plus\qt\MediaPlayer -extensions qml -ts F:\dao-tao\ngon-ngu-lap-trinh\learning.nentang.vn-c-plus-plus\qt\MediaPlayer\translations\lang_en_US.ts
lupdate F:\dao-tao\ngon-ngu-lap-trinh\learning.nentang.vn-c-plus-plus\qt\MediaPlayer -extensions qml -ts F:\dao-tao\ngon-ngu-lap-trinh\learning.nentang.vn-c-plus-plus\qt\MediaPlayer\translations\lang_vi_VN.ts
```

2. Sử dụng Qt Linguist để dịch các ngôn ngữ -> save file lại
3. Chạy câu lệnh để tạo file `.qm`
```
lrelease F:\dao-tao\ngon-ngu-lap-trinh\learning.nentang.vn-c-plus-plus\qt\MediaPlayer\translations\lang_vi_VN.ts
lrelease F:\dao-tao\ngon-ngu-lap-trinh\learning.nentang.vn-c-plus-plus\qt\MediaPlayer\translations\lang_en_US.ts
```