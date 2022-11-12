#include<bits/stdc++.h>
#include <iostream>
using namespace std;

/*
Cho đồ thị vô hướng G=<V,E> được biểu diễn dưới dạng ma trận kề. 
Hãy viết chương trình thực hiện chuyển đổi biểu diễn đồ thị dưới dạng danh sách cạnh.

Input
Dòng đầu tiên chứa số n là số đỉnh của đồ thị (1 <= n <= 1000)
N dòng tiếp theo, mỗi dòng N số biểu diễn ma trận kề của đồ thị.

Output
In ra danh sách cạnh tương ứng của đồ thị, liệt kê theo thứ tự tăng dần của các đỉnh
*/

int n, m; //n: dinh, m: canh
int a[1001][1001]; // ma tran ke
vector<pair<int, int>> edge; // danh sach canh

int main() {
	// Chuyen NHAP, XUAT thanh file
	freopen("lab1_3_input.INP", "r", stdin);
	freopen("lab1_3_output.OUT", "w", stdout);
	
	// INPUT
	cin >> n;
	for(int i = 1; i <= n; i++) {
		for(int j = 1; j <= n; j++) {
			cin >> a[i][j];
		}
	}
	
	// In ra ma tran ke vua lay duoc
//	cout << "Ma tran ke: " << n << " dinh" << endl;
//	for(int i = 1; i <= n; i++) {
//		for(int j = 1; j <= n; j++) {
//			cout << a[i][j] << " ";
//		}
//		cout << endl;
//	}
	
	// Luu vao danh sach canh
	for(int i = 1; i <= n; i++) {
		for(int j = 1; j <= n; j++) {
			if(a[i][j] == 1
				&& i < j) // Do thi vo huong, khong duoc trung lap 2 canh
			{
				edge.push_back({i, j});
			}
		}
	}
	
	// OUTPUT, danh sach canh
	for(auto item: edge) {
		cout << item.first << " " << item.second << endl;
	}
}
