#include<bits/stdc++.h>
#include <iostream>
using namespace std;

/*
Cho đồ thị vô hướng G=<V,E> được biểu diễn dưới dạng danh sách kề. 
Hãy viết chương trình thực hiện chuyển đổi biểu diễn đồ thị dưới dạng ma trận kề.

Input
Dòng đầu tiên chứa số n là số đỉnh của đồ thị (1 <= n <= 1000)
N dòng tiếp theo, mỗi dòng là danh sách kề của các đỉnh từ đỉnh 1 đến đỉnh n

Output
In ra ma trận kề tương ứng của đồ thị.
*/

int n, m; //n: dinh, m: canh
int a[1001][1001]; // ma tran ke
vector<int> adj[1001]; // danh sach ke

int main() {
	// Chuyen NHAP, XUAT thanh file
	freopen("lab1_5_input.INP", "r", stdin);
	freopen("lab1_5_output.OUT", "w", stdout);
	
	// INPUT
	cin >> n;
	cin.ignore();
	for(int i = 1; i <= n; i++) {
		string s, str_num;
		int num;
		getline(cin, s);
		stringstream ss(s);
		while(ss >> str_num) {
			num = stoi(str_num);
			a[i][num] = 1;
		}
	}
	
	// OUTPUT, ma tran ke
	for(int i = 1; i <= n; i++) {
		for(int j = 1; j <= n; j++) {
			cout << a[i][j] << " ";
		}
		cout << endl;
	}
}
