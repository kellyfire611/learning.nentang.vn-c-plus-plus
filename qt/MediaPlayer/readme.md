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

# Cài đặt TagLib
## Cách 1. Install `vcpkg`
```
git clone https://github.com/microsoft/vcpkg
.\vcpkg install taglib:x64-mingw-dynamic
```

- Gắn vào Qt:
```
# Thêm đường dẫn đến vcpkg
set(CMAKE_PREFIX_PATH "F:/dao-tao/ngon-ngu-lap-trinh/research/libs/vcpkg/installed/x64-windows")

# Tìm gói TagLib
find_package(Taglib REQUIRED)

# Liên kết với TagLib
target_link_libraries(appMediaPlayer PRIVATE TagLib::tag TagLib::tag_c)
```

## Cách 2: tự build
2. Clone source taglib từ github
3. Chạy câu lệnh cài đặt thư viện con
```
git submodule update --init
```

4. Build source
```
# Adapt these environment variables to your directories
PATH=$PATH:/f/Qt/Tools/mingw1310_64/bin
TAGLIB_SRC_DIR=F:/libs/taglib
TAGLIB_DST_DIR=F:/libs/build

cd $TAGLIB_SRC_DIR
F:/phan-mem/tool/cmake/bin/cmake -B $TAGLIB_DST_DIR -DBUILD_SHARED_LIBS=ON -DVISIBILITY_HIDDEN=ON \
  -DBUILD_EXAMPLES=ON -DBUILD_BINDINGS=ON -DWITH_ZLIB=OFF \
  -DCMAKE_BUILD_TYPE=Release -G 'MinGW Makefiles'
F:/phan-mem/tool/cmake/bin/cmake --build $TAGLIB_DST_DIR --config Release

PATH=$PATH:$TAGLIB_DST_DIR/taglib \
  $TAGLIB_DST_DIR/examples/tagreader F:/libs/examples/Tuyet_Yeu_Thuong_Remix.mp3

# Install to F:\pkg_mingw
F:/phan-mem/tool/cmake/bin/cmake --install $TAGLIB_DST_DIR --config Release --prefix /f/pkg_mingw --strip
```

5. 
```
TAGLIB_PREFIX=/f/pkg_mingw
F:/phan-mem/tool/cmake/bin/cmake -B build_mingw -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$TAGLIB_PREFIX -G 'MinGW Makefiles'
F:/phan-mem/tool/cmake/bin/cmake --build build_mingw --config Release

PATH=$PATH:$TAGLIB_PREFIX/bin
  build_mingw/tagreader F:/libs/examples/Tuyet_Yeu_Thuong_Remix.mp3
```