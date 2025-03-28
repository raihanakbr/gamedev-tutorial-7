# **GameDev Tutorial 7**

Dalam tutorial ini, saya memahami perbedaan antara pengembangan game 2D dan 3D, seperti penggunaan node 3D, teknik raycasting untuk interaksi objek, serta pembuatan level menggunakan **Constructive Solid Geometry (CSG)**. Latihan-latihan yang disertakan membantu saya menguasai gerakan karakter dalam ruang 3D, interaksi dengan objek, dan desain level yang efektif, sehingga memberikan pemahaman yang lebih baik tentang dasar-dasar pengembangan game 3D.

---

## **Fitur yang Diimplementasikan**

### **1. Sistem Pengambilan Item & Inventori**
Fitur ini memungkinkan pemain untuk mengambil item yang ada di dalam dunia game dan menyimpannya dalam sistem inventori. Inventori ditampilkan dalam UI dan akan diperbarui secara dinamis saat pemain menambahkan item baru.

#### **Implementasi:**
- **Pengambilan Item**:  
  - `RayCast3D` digunakan untuk mendeteksi objek yang dapat diambil di depan pemain.
  - Saat pemain menekan tombol "interact", item akan ditambahkan ke dalam inventori dan dihapus dari dunia game.
  - Setiap item memiliki **ikon** dan **scene_file_path** untuk ditampilkan dalam inventori serta diinstansiasi kembali saat digunakan.
- **Manajemen Inventori**:  
  - Inventori disimpan secara global dalam script `Globals.gd`.
  - Script `InventoryUI.gd` memperbarui UI inventori secara dinamis agar sesuai dengan item yang ada.
  - Objek yang disimpan dalam inventori bisa diinstansiasi dengan menekan angka sesuai slot inventorinya, yakni 1-9. Objek akan muncul di bawah player (yep this is totally ~~un~~intended becaues i love freefire)

#### **Script Utama:**
- `PickableItem.gd` → Menentukan properti item (misalnya, ikon).
- `ray_cast_3d.gd` → Mengelola deteksi item dan interaksi.
- `Globals.gd` → Menyimpan daftar inventori secara global dan mengirimkan sinyal pembaruan.
- `InventoryUI.gd` → Memperbarui tampilan UI inventori.

---

### **2. Sprinting & Crouching**
Fitur ini memungkinkan pemain untuk bergerak dengan kecepatan berbeda sesuai dengan input:
- **Sprinting** → Meningkatkan kecepatan gerak pemain.
- **Crouching** → Mengurangi kecepatan gerak dan menyesuaikan tinggi karakter.

#### **Implementasi:**
- **Sprinting**:
  - Aksi "sprint" dikaitkan dengan tombol tertentu di pengaturan input.
  - Saat tombol sprint ditekan, kecepatan pemain dikalikan dengan faktor percepatan sprint.
- **Crouching**:
  - Aksi "crouch" dikaitkan dengan tombol tertentu.
  - Saat pemain berjongkok, tinggi karakter dan kecepatan gerak akan berkurang.
  - Perubahan tinggi karakter dibuat lebih halus menggunakan linear interpolation (`lerp`).

#### **Script Utama:**
- `Player.gd` → Mengatur gerakan pemain, sprinting, dan crouching.
- `CollisionShape3D` → Menyesuaikan tinggi karakter secara dinamis saat crouching.

---

## **Control**
- **Gerakan**: Gunakan `W`, `A`, `S`, `D` untuk bergerak.
- **Sprint**: Tahan `Shift` untuk berlari.
- **Crouch**: Tahan `Ctrl` untuk berjongkok.
- **Interaksi**: Tekan `E` untuk mengambil item.

---

## **Notes**
- UI inventori masih sederhana dan diperbarui dengan cara menghapus serta membuat ulang slot.
- Sistem crouching memiliki transisi yang halus untuk tinggi karakter dan posisi kamera.
- Sprinting dan crouching tidak bisa dilakukan secara bersamaan (misalnya, pemain tidak bisa berlari saat sedang jongkok).

---