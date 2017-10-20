# colorcode
2014年の前期、大学二回生で受けた「プログラミング基礎演習Ⅱ」の最終課題
255，255，255というようなカラーコードと，色の名前が単に含まれているデータから，カラーコードのテーブルを作成するもの．
 
 ファイル名：colorcode.rb
# 作成日：2015/06/27
# 作成者：Eri Nakahara
# 説明　：色の名前とその数値表現を列挙したファイルから
# 　　　　色の名前を色付けして表現した表を組み込んだ HTML ファイル と
# 　　　　CSS ファイルを書き出すプログラムです。
#        
# 使用例：ruby colorcode.rb
# 備考：データファイルがカレントディレクトリにない場合は、
#      下記URLからデータを入手します。
#      http://people.csail.mit.edu/jaffer/Color/rgb.txt
#      rgb.txtには例えば"248 248 255 ghost white","248 248 255 GhostWhite"といった、
#      rgb値が同じで、色名の#間にスペースがあるものが含まれています。
#      色はどちらも同じなので、スペースを含む色名は除いています。
#      rgb値の合計が高い色は白っぽくなり、背景と同化して見づらいので、背景色を黒にしています。
#        
