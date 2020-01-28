require "csv"
require "gnuplot"
require_relative "./Perceptron"

def main
  # 学習用データを取得
  inputs = CSV.read("./trainingData.csv")

  # ファイル読み込みはString型なので各要素をNumeric型に変換
  inputs = inputs.map{|in2| in2.map(&:to_i)}

  # 学習用データを入力と出力で分割
  input_data = Array.new(inputs.size).map {Array.new(2)}
  input_ans = Array.new(inputs.size)
  inputs.size.times do |i|
    input_data[i] = inputs[i].slice(0..1)
    input_ans[i] = inputs[i][-1]
  end

  # 学習を開始(学習用データ全てに正答するまで学習し続ける)
  cnt = 0
  perceptron = Perceptron.new(0.002)
  plot_border(perceptron, input_data, "0")
  loop do
    perceptron.forward(input_data, input_ans, true)
    puts "cnt:#{cnt += 1} w1:#{perceptron.weight[0]} w2:#{perceptron.weight[1]} flag:#{perceptron.is_all_corrected}"
    p perceptron.output
    p perceptron.activated_output
    puts

    # 学習データの散布図と，学習した境界線を表示
    plot_border(perceptron, input_data, String(cnt))
    break if perceptron.is_all_corrected
  end # loop
end

# 学習した結果を描画したい
def plot_border(perceptron, input_data, save_name)
  # グラフの描画範囲
  xrange = [*-50..180]
  yrange = [*-50..180]

  # 横幅，高さをそれぞれ抜き出し
  width = input_data.transpose[0]
  height = input_data.transpose[1]

  # 境界線データを作成
  border_x = xrange
  border_y = border_x.map{|xll| xll *(perceptron.weight[0] / perceptron.weight[1] * (-1))}

  Gnuplot.open do |gp|
    Gnuplot::Plot.new(gp) do |plot|
      plot.terminal "png enhanced font 'ＭＳ ゴシック' fontscale 1.2 size 1000, 1000"
      plot.output   save_name + ".png"
      plot.title    "データの分布と境界線"
      plot.xlabel   "Width"
      plot.ylabel   "Height"
      plot.xrange   "[" + String(xrange[0]) + ":" + String(xrange[-1]) + "]"
      plot.yrange   "[" + String(yrange[0]) + ":" + String(yrange[-1]) + "]"
      plot.grid

      # 入力データの散布図
      plot.data << Gnuplot::DataSet.new([width, height]) do |ds|
        ds.with = "circles"
        ds.linecolor = 'rgb "red"'
        ds.notitle
      end # do

      # 重みの境界線
      plot.data << Gnuplot::DataSet.new([border_x, border_y]) do |ds|
        ds.with      = "lines"  # 点のみなら "points"
        ds.linewidth = 3
        ds.linecolor = 'rgb "blue"'
        ds.notitle
      end # do

      # X軸の描画
      xl = [xrange[0], xrange[-1]]
      plot.data << Gnuplot::DataSet.new([xl, Array.new(2,0)]) do |ds|
        ds.with      = "lines"  # 点のみなら "points"
        ds.linewidth = 1
        ds.linecolor = 'rgb "black"'
        ds.notitle
      end # do

      # Y軸の描画
      yl = [yrange[0], yrange[-1]]
      plot.data << Gnuplot::DataSet.new([Array.new(2,0), yl]) do |ds|
        ds.with      = "lines"  # 点のみなら "points"
        ds.linewidth = 1
        ds.linecolor = 'rgb "black"'
        ds.notitle
      end # do
    end # do
  end # do
end

# コマンドラインから呼び出されたときのみ実行する
if __FILE__ == $0
  main
end
