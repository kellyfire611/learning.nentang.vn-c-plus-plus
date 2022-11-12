#include<bits/stdc++.h>
#include <iostream>
using namespace std;

/*
Cho đồ thị vô hướng G=<V,E> được biểu diễn dưới dạng danh sách cạnh. 
Hãy viết chương trình thực hiện chuyển đổi biểu diễn đồ thị dưới dạng ma trận kề.

Input
Dòng đầu tiên chứa 2 số n, m là số đỉnh và số cạnh của đồ thị (1 <= n <= 1000, 1 <= m <= n*(n-1)/2).
M dòng tiếp theo, mỗi dòng là 2 số u, v biểu diễn cạnh u, v của đồ thị (1 <= u, v <= n). Các cạnh được liệt kê theo thứ tự tăng dần của các đỉnh đầu.

Output
In ra ma trận kề tương ứng của đồ thị
*/

int n, m; //n: dinh, m: canh
int a[1001][1001];

int main() {
	// Chuyen NHAP, XUAT thanh file
	freopen("lab1_1_input.INP", "r", stdin);
	freopen("lab1_1_output.OUT", "w", stdout);
	
	// INPUT
	cin >> n >> m;
	for(int i = 0; i < m; i++) {
		int x, y;
		cin >> x >> y;
		a[x][y] = a[y][x] = 1; // Do thi vo huong
	}
	
	// OUTPUT, ma tran ke: n dinh x n dinh
	for(int i = 1; i <= n; i++) {
		for(int j = 1; j <= n; j++) {
			cout << a[i][j] << " ";
		}
		cout << endl;
	}
}
