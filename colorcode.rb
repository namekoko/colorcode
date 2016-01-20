# coding: utf-8
############################################################################
# ファイル名：colorcode.rb
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
############################################################################

require 'open-uri'
#####################################
# データファイル (rgb.txt) の存在チェック
#####################################
rgb_file = "rgb.txt"

flg = false
if ! File.exist?(rgb_file)
  puts "#{rgb_file} が存在しません．ダウンロードしますか(Y/N)"
  if /[Yy]/ =~ STDIN.gets then
    flg = true
  else
    puts "処理を中断します．"
    exit 
  end
end
#####################################
# データファイル (rgb.txt) をダウンロード
######################################
if flg then
  begin
    open("http://people.csail.mit.edu/jaffer/Color/rgb.txt") do |f|
      File.open(rgb_file,"w") do |fp| # 書き込みモードでオープン
        fp.write f.read
      end
    end
  rescue SocketError #オフライン時の処理
    puts "ネットワークがつながっていません."
    exit
  end
end

#=end

###################################################################
#rgb.txtを読み込んで、意味のある行だけ正規表現で拾い出し、配列 colorsに格納。
##################################################################

def get_rgb
  file = "rgb.txt"
  colors = Array.new
  File.open(file) do |f| #一行読み込んで変数colorsに格納
    f.each_line do |items|
      if /(^\s*\d+)\s+(\d+)\s+(\d+)\s+(\w.+)/  =~ items then
        r,g,b,name = $1,$2,$3,$4
        if /\s\w/ !~ name #色名にスペースが含まれているものを除く。
          colors << [r.to_i,g.to_i,b.to_i,name]
        else
          #break
        end
      end
    end
  end
  return colors
end

#################################
#スタイルファイル(colors.css)の作成
################################

def print_css(colors,fc)
  colors.each do |r,g,b,name|
    fc.printf(".#{name}{color:#%02X%02X%02X;}\n",r,g,b)
  end   
  colors.each do |r,g,b,name|
    sum =r.to_i+g.to_i+b.to_i
    if sum > 500 then # rgb値が高くて白に近い色の背景色は黒にする
      fc.printf(".#{name}{color:#%02X%02X%02X;background-color:#000000}\n",r,g,b)
    end
  end
end

#################################################################################
#  num_colsでテーブルの列数を指定。　colorsの配列を使い,r,g,b,nameを列数分ずつ配列で区切る。
#################################################################################

def make_rows(colors,num_cols)
  rows = colors.dup
  max = rows.size
  rows2 = []
  while rows
    rows2 << rows[0 ... num_cols]
    rows = rows[num_cols .. max]
  end
  rows2.pop if rows2.last.empty?
  return rows2
end

################
# テーブルの作成
###############

def print_table(rows,fh)
 fh.puts "<table border='1' cellpadding='5'>"
  rows.each do |row|
    fh.puts "<tr>"
    row.each do |r|
      str = r[0..2].map{|e|"<td>#{e}</td>"}.join("")
      str += "<td class='#{r[3]}'>#{r[3]}</td>"
      fh.puts str
    end
    fh.puts "</tr>"
  end
  fh.puts "</table>"
end

#############
#ヘッダーの作成
############

def print_header(title,fh)
  style_file  = "colors.css" 
  fh.print <<HTMLHEAD
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8" />
<link rel="stylesheet" type="text/css" href="#{style_file}" />
<title>#{title}</title>
</head>
<body>
<h1>#{title}</h1>
HTMLHEAD
end

########################
#</body>,</html>を出力
#######################

def print_close(fh)
  fh.puts "</body>"
  fh.puts "</html>"
end

##################################
#htmlファイル, スタイルファイルの生成
##################################

html_file = "colors.html" 
css_file = "colors.css"
colors = get_rgb
rows = make_rows(colors,4)

File.open(html_file,"w") do |f| 
  print_header("色の英語名",f)
  print_table(rows,f)
  print_close(f)
end

File.open(css_file,"w") do |f|
  print_css(colors,f)
end





