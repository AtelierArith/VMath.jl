---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.11.2
  kernelspec:
    display_name: Julia 1.6.1
    language: julia
    name: julia-1.6
---

# 特異モデルの統計学

これはテキスト$\underset{\textrm{def}}{=}$ [特異モデルの統計学 (統計科学のフロンティア 岩波書店)](https://www.iwanami.co.jp/book/b260373.html) の Chapter 1 section 1 の部分について触れた日本語で記述されたお勉強ノートである.


# モチベーション

- 統計的推測のモチベーションから話を始める. $N$ 次元の $n$ 個からなる数値データ $x^n$ が与えられたとする:
$$
x^n \underset{\textrm{def}}{=} (x_1,\dots, x_n), \quad x_i \in \mathbb{R}^N.
$$
$x^n$ の上にある $n$ は冪乗の意味ではなく長さが $n$ の列(同じことではあるが $n$ 個の要素からなる組み)という程度の意味で用いている. 我々はこのデータの発生源の性質を調べたいとする. 例えば 
$$
\mu_n \underset{\textrm{def}}{=} \bar{x}_n \underset{\textrm{def}}{=} \frac{1}{n}\sum_{i=1}^n x_i
$$
という量を計算し, "それっぽい"ことをしたいわけである. "それっぽい"というのは流石に語彙力が貧弱すぎるのでもう少しちゃんとした言い方に改めよう. データの発生源が何かしらの確率分布 $q$ に従っているとし, 分布 $q$ の平均 $\mu$ は「ま〜だいたい $\mu_n$でしょう」と思うことである. さらにいろんな方法のそれっぽいことをすることでデータの発生源の分布 $q$ は平均 $\mu$ で分散が $\sigma^2$ の正規分布だろうなと思うことができる. 思うという部分はフォーマルにいえば「推測」すると言い換えられる. このように与えられたデータ $x^n$ から $q$ を推測することを統計的推測と呼ぶ. $q$ は真の分布と呼ばれることもある.


# 定式化への一歩

- 先程のべた「ま〜だいたい $\mu_n$でしょう」な言い方も依然としてラフな印象を持たれかねない.もっとフォーマルな言い方にしたい.「だいたい〜でしょう」とポロッと言ってしまうのはデータの取得（実験などで観測）をするごとに得られるデータは変化するからだ. (なるほど，語彙力が貧弱でもその辺はちゃんと考えているようだ.) データが変化するともちろん上で求めた $\mu_n$ の値はそれに応じて変わってしまう. この「変わってしまう」というのを系統的に理解したくなる. 幸い，先人の知恵によって定式化する道具が作られてきた. それは人の立場によって機械学習だったりデータサイエンスだったり統計学だったり確率論だったりする. ここでは参考にするテキスト通りに「統計学」としよう. 何にせよ共通することは程度の差があれど数学が用いられているということだ. 
- 数学を使うと直感的に出てくる「アレ」や「ソレ」というのを定式化し文章にして記述することができる. ここで出てくる語彙力不足な人でも（ある程度忍耐があれば）先人が培ってきた道具を用いて説明・語彙力を補えるはずである. もしかしたら今までにわかっていなかったことがわかってくるかもしれない. もしかしたら経験的に知られていることを見通しよく理解することができるかもしれない. それは我々に良い知見を与えることになる．


# 定式化への $N\geq 2$ 歩

- 駄文はこれぐらいにして議論の出発点を決めるために真面目に記号や予備知識の整備を進める. 例えば用語の定義をしたり，問題設定をしたり，考える対象についていくつかの仮定をおく作業である. 
- このノートブックでは上記で出てきたような $x^n$ はサンプルと呼ばれるある $n$ 個の確率変数 (random variable) 
$$
X^n=(X_1,\dots, X_n)
$$
の実現値とみなす定式化を図る. こうすることで上記の「変わってしまう」というのを定式化できる. 例えば $\mu_n = \sum x_i/n$ としていた部分は
$\bar{X} = \sum X_i /n $ という形の確率変数の性質を調べることに帰着される. 
- $X_i$ は確率変数なのでそれが従う分布についての視点も必要になってくる. このノートブックでは $X^n=(X_1,\dots, X_n)$ に対して次の仮定を置く:
  - $X^n=(X_1,\dots, X_n)$ は独立であり, 各々の $X_i$ は同一の分布 $q$ に従うものとする. これを `i.i.d` (independently and identically distribution の略) と呼び
$$
X^n=(X_1,\dots, X_n) \underset{\textrm{i.i.d}}{\sim} q
$$
と書く.
  - $q$ を真の分布と呼ぶ. 分布とは述べているものの, 数学的な操作の際に確率密度関数として用いられる.
  - この表記はしばしば次のように濫用することがある. 例えば $X^n$ が i.i.d でであり, 分布が平均が $\mu$ で $\sigma^2$ が分散の正規分布 $\mathcal{N}(\mu, \sigma^2)$ である場合は
  $$
  X^n \underset{\textrm{i.i.d}}{\sim} \mathcal{N}(\mu, \sigma^2)
  $$ 
  のように記述する. さらに $q=\mathcal{N}(\mu, \sigma^2)$ と書いたり, 密度関数であることを明示するために $q(x) = \mathcal{N}(x; \mu, \sigma^2)$ という表記もする.


#### Prop: 

- $X^n \underset{\textrm{i.i.d}}{\sim} \mathcal{N}(\mu, \sigma^2)$ なる確率変数 $X^n=(X_1,\dots,X_n)$ に対して
$$
\bar{X} = \frac{1}{n}\sum_{i=1}^n X_i
$$
とおく. このとき次が成り立つ:
$$
\bar{X} \sim \mathcal{N}(\mu, \sigma^2/n).
$$
特に
$$
\begin{aligned}
Z_i &= \frac{1}{\sigma}(X_i - \mu), \\
\bar{Z} &= \frac{1}{n}\sum_{i=1}^n Z_i
\end{aligned}
$$
と定義すると
$$
\sqrt{n}\bar{Z} = \frac{1}{\sqrt{n}} \sum_{i=1}^n Z_i = \frac{1}{\sqrt{n}} \sum_{i=1}^n \frac{X_i - \mu}{\sigma} \sim \mathcal{N}(0, 1)
$$
となる.

- この命題は(確率変数が正規分布であることもあり)任意の $n$ について exact に成り立っている. 統計的推測のでは $n\to\infty$ の極限で対象とする統計量(確率変数)がどうなるかを知りたいことが多い. 例えば $X^n$ の平均を ($n$ を明示的に書いて) $\bar{X}^{(n)} = \sum_i X_i/n$ と書いた時に

$$
\bar{X}^{(1)}, \bar{X}^{(2)}, \bar{X}^{(3)}, \dots, \bar{X}^{(n)} \dots
$$

という確率変数の列がどのようなものに「収束」するのかを知りたい.「収束」と書いた理由は,確率変数は通常の数ではなく(根源事象 $\omega\in\Omega$) 上の $\mathbb{R}^N$-値関数なので関数としてのどのような意味で収束するのかというのを明示的に述べる必要がある.


#### Remark

このノートブックを通して特に断らない限りサンプル $X^n$ は i.i.d であると仮定する.


# 収束の話

- このノートブックで必要な(主に $\mathbb{R}^1$-valued な)確率変数の収束の概念について述べる. 多くの事柄は [現代数理統計学の基礎 (共立出版)](https://www.kyoritsu-pub.co.jp/bookdetail/9784320111660) から引用している. 細かい証明やステートメント(特に大数の弱・強の法則について気になる場合) は [確率論 (朝倉書店)
](http://www.asakura.co.jp/books/isbn/978-4-254-11600-7/) を各自確認すると良い.
- 時折 $P$ が出てくるがこれは確率変数 $X$ が確率空間(=標本空間, 完全加法族, 確率測度 からなる三つ組) $(\Omega, \mathcal{F}, P)$ 上のものとして与えられていると思えば良い.

#### Def (確率収束):

- 確率変数の列 $\{X_n\}$ と確率変数 $X$ が
$$
\lim_{n\to\infty} P(|X_n - X| > \epsilon) = 0 \quad \textrm{for}\quad \epsilon > 0
$$
を満たすとき, $\{X_n\}$ は $X$ に確率収束するという. 記号として
$$
X_n \to_p X
$$
を用いる.
直感的にいえばあらかじめ与えた正の数 $\epsilon$ に対して $X_n$ と $X$ の誤差がそれ以上になる確率が 0 に収束するということである.

#### Prop(大数の法則):

- 平均が $\mu$ で有限の分散 $\sigma^2$ を持つ i.i.d 確率変数列 $\{X_i\}_{i=1}^n \sim (\mu, \sigma^2), \sigma^2 < +\infty$ に対して
$$
\bar{X}^{(n)} = \frac{1}{n}\sum_{i=1}^n X_i
$$
このとき $\bar{X}^{(n)}$ は $\mu$ に確率収束する.

#### Def (分布関数・累積分布関数):

- 確率変数 $X$ に対してその(累積)分布関数 $F_X(x)$ を次で定義する:
$$
F_X(x) = P(X\leq x)
$$
直感的には $x$ よりも小さい値を取る確率である.

#### Def (法則収束):

- 確率変数の列 $\{X_n\}$ と確率変数 $X$ が $F_X$ の連続点 $x$ に対して
$$
\lim_{n\to\infty} F_{X_n}(x) = F_X(x)
$$
を満たすとき, $\{X_n\}$ は $X$ に確率収束するという. 記号として
$$
X_n \to_d X
$$
またはテキストに合わせて
$$
X_n \Rightarrow X
$$

を用いる. 直感的にいえばある範囲 $a$ からある範囲 $b$ までの値をとるうる確率 $P(a\leq X_n \leq b)$ が $P(a\leq X \leq b)$ に収束するということを述べている.

#### Prop(中心極限定理):

- CLT(Central Limit Theorem) とも呼ばれる.
- $\mu$, $\sigma^2 \in (0, \infty)$ なる i.i.d な確率変数列 $\{X_i\}_{i=1}^n$ に対して
$$
\bar{X}^{(n)} = \frac{1}{n}\sum_{i=1}^n X_i
$$
とおく. このとき
$$
Z \underset{\textrm{def}}{=}\sqrt{n}(\bar{X}^{(n)} - \mu)/\sigma = \frac{1}{\sqrt{n}} \sum_{i=1}^n \frac{X_i - \mu}{\sigma} \to_d \mathcal{N}(0, 1).
$$

#### Prop:

- 確率収束するなら分布収束する.

#### Prop(スラツキーの定理):

- Slutsky's theorem
- 分布収束する確率変数列 ${U_n} \to_d U$ と定数 $a$ に確率収束する確率変数列 ${V_n} \to_p a$ に対して次が成り立つ:
$$
\begin{aligned}
U_n + V_n &\to_d U + a \\
U_nV_n &\to_d Ua
\end{aligned}
$$

#### Prop:

- 確率収束や分布収束は連続関数によって引き継がれる. すなわち連続関数 $f$, 確率変数列 $\{X_n\}$, 確率変数 $X$ に対して次が成り立つ:
  - $X_n \to_p X$ ならば $f(X_n) \to_p f(X)$.
  - $X_n \to_d X$ ならば $f(X_n) \to_d f(X)$.


# 確率モデルの設定

- 数値データ $x^n$ からそのデータの発生源である真の分布 $q$ を知りたい. それが統計的推測のモチベーションである. $q(x)$ は何かは実際のところ不明なことが多い. 実際は正規分布かもしれないし, ラプラス分布かもしれないし, ポアソン分布かもしれないし，冪分布かもしれないし, 一様分布かもしれない, も〜しかしたらそれらを混ぜ合わせた混合分布かもしれない.
- $q$ はどうなるかわからないけれど我々人間は「何かしらの理由（対象となるデータに関する事前知識から）で何かしらの分布になっているだろう」という予想を立てるぐらいはできるだろう.
  - 例えば, 与えられたデータは何かしらの理由で原理的には分散が 1 の正規分布に従っているとわかっているとする. 一方で平均は未知であって実際のところはよくわかっていないとしよう. そのような場合は「真の分布は $\mu$ をパラメータとして持っている $\mathcal{N}(\mu, 1)$ のどれかだろう」と仮定を置くのは自然である. $\mu$ の推定はデータ $x^n$ を用いて解析すれば良い. 理論の展開は $x^n$ の代わりに確率変数 $X^n$ の方を用いることになる.
- このようにパラメータ $\theta\in \Theta$ (一般には多次元の部分集合)によってパラメトライズされる確率密度関数の族 
$$
\{f(x|\theta)\}_{\theta\in\Theta}
$$
を用意しデータ $x^n$ or $X^n$ からそのパラメータを推測するという問題に帰着させてみよう. $f(x|\theta)$ を確率モデルと呼ぶ.


### すいません

テキストだとこのノートブックでの確率モデルのことを統計モデルって書いてました. 言ってることは同じなので許してください.


### $\iota$ 話

与太話と駄洒落したかっただけですすいません(深夜テンション)


 確率モデルの選択は人間が選ぶものなのでその問題設定が（確率モデルの選び方）が適切かは別問題である. 先程の例では正規分布を既知として述べたが実はそれが嘘で（その情報がテキトーな人が言った戯言だった）真の分布がラプラス分布だったかもしれない. それはそれでしょうがない. またそこで与えた確率モデルが他のそれに比べて良いのか悪いのかという比較する方法も気になってくる.
  - [ベイズ統計の理論と方法](https://www.coronasha.co.jp/np/isbn/9784339024623/) では上記の確率モデル $f(x|\theta)$ に加え, 確率モデルのパラメータの分布 $\varphi(\theta)$ を用意し $(q,f,\varphi)$ の三つ組を用意しベイズ推測による統計的推論の定式化を図っている. そこでは３組の（特に確率モデルや事前分布の選び方が真の分布に対して適切かに関わらない）数学的法則を紹介している.
  - 誤植が多いので怪しいところは著者のページにアクセスすると良い.
  - また値は張るが洋書(`Mathematical Theory of Bayesian Statistics`) もある.
  - 代数幾何学の話も出てくるが`代数幾何と学習理論` や `Algebraic Geometry and Statistical Learning Theory` で補える. 人によってはこちらの方から統計学に対する興味を持てる人もいるだろう.


## 確率モデルを用いた最尤推定法によるパラメータ推定の例

- 確率モデル $f(x|\theta) = \frac{1}{(2\pi)^{1/2}}\exp\left(-\frac{1}{2}(x-\theta)^2\right)$ が与えられているとする. i.i.d なサンプル $X^n$ から $\theta$ を推定したい.
- ここでは最尤推定によって求める. 対数尤度
$$
\sum_{i=1}^n \log f(X_i | \theta)
$$
が最大となる $\theta$ を探せば良い. このような $\theta$ を $\hat{\theta}$ or $n$ を明示的につけて $\hat{\theta}_n$ と書いて最尤推定量と呼ぶ. この場合は対数尤度の極値を与える点を求めることに帰着される.
$$
\sum_{i=1}^n \log f(X_i | \theta) = -\frac{1}{2}\sum_{i=1}^n (X_i - \theta)^2 + \textrm{const.}
$$
だから
$$
\hat{\theta}_n = \frac{1}{n}\sum_{i=1}^n X_i
$$
で与えられる. このようにしてサンプルから確率モデルから推定量を得た. 具体的な数値データ $x^n$ ではなく確率変数 $X^n$ の方を用いると推定量が確率変数とみなせ, 推定量の統計的な性質を解析することができる.
- さて，運よく真の分布が確率モデルによって実現可能だとする. すなわち
$$
q(x) = f(x|\theta_0) \ \ \textrm{for some}\ \theta_0 \in \mathbb{R}
$$
だとする.
今回の場合. $X_i \sim \mathcal{N}(\theta_0, 1)$ だから
$$
\hat{\theta}_n \sim \mathcal{N}(\theta_0, 1/n)
$$
すなわち
$$
\sqrt{n}(\theta_n - \theta_0) \sim \mathcal{N}(0, 1)
$$
となる. わかっている人は右辺は $\mathcal{N}(0, 1)$ の代わりに $\mathcal{N}(0, 1/1)$ と書きたくなる. これは分散項が後述する サンプルが1 の Fisher 情報量 $I_1$ の逆数になるからである. この確率モデルだと Fisher 情報量が 1 になる.


# 漸近理論

- 今回は問題設定を単純にであるから最尤推定量と誤差分布が exact に求められたが, 一般にはそれが難しい. $n$ (サンプル数と呼ぶ)が十分大きいときに最尤推定量の統計的性質を求めるアプローチがあるそれを統計的漸近理論と呼ぶ. 和書では
  - [必携統計的大標本論 (共立出版)](https://www.kyoritsu-pub.co.jp/bookdetail/9784320111370)
  - [統計的推測の漸近理論 (九州大学出版会)](https://kup.or.jp/booklist/ns/science/696.html)
などの本がある.
- 真の分布が実現可能でそれが $q=f(x|\theta_0)$ と得られたとする. ある種の正則条件(確率モデルについて良い条件)のもとではサイズが $n$ の最尤推定量 $\hat{\theta}_n$ は
$$
\sqrt{n}(\hat{\theta}_n - \theta_0) \to_d \mathcal{N}(0, I^{-1}(\theta_0))
$$
のように法則収束することが知られている. ここで $\theta_0$ は 1 次元に限らない. $I$ は後述する Fisher 情報量行列である.


# 推定量の話

真の分布が $q(x) = f(x|\theta_0)$ で与えられ, サンプル $X^n$ から確率モデル $f(x|\theta)$ のパラメータ $\theta$ を何かしらの方法で推定することを考える. 得られた結果が $\hat{\theta}$ であるとする. 一般的には
$$
\hat{\theta}(X^n) = \hat{\theta}(X_1,\dots,X_n)
$$
のように $X^n$ に依存する量であり実は定義の方法は色々考えられる. その中で良いものを探したい. 良い指標としては不偏性 unbiased がある. 

$$
E_{X^n}[\hat{\theta}(X^n)] = \theta_0
$$

例えば $\theta$ が平均 $\mu$ に関するパラメータだとする.
$$
\hat{\theta} = \bar{X} = \frac{1}{n}\sum_{i=1}^n X_i
$$
と置くと
$$
E[\hat{\theta}] = \frac{1}{n}\sum_{i=1}^n E[X_i] = \frac{1}{n}\sum_{i=1}^n \mu = \mu
$$
なのでこの $\hat{\theta}$ は不偏推定量(unbiased estimator)であることがわかる. ただし, 今回の場合はサンプルが i.i.d であるため実は下記のような選び方をしても不偏推定量となる:

$$
\begin{aligned}
\hat{\theta} &= \bar{X} = \frac{1}{n}\sum_{i=1}^n X_i, \\
\hat{\theta} &= X_1, \\
\hat{\theta} &= (X_1 + X_2)/2, \\
\hat{\theta} &= \frac{1}{n}\sum_{i=1}^n c_iX_i \quad \textrm{where} \quad \sum_{i=1}^n c_i = 1 \\
\end{aligned}
$$


色々な選び方がある中で良いものはというと推定量の分散が小さいものを選べば良さそうである. ひとまず上の設定を引き続き進め，サンプルの線形和による推定量について注目する:

$$
\hat{\theta} = \frac{1}{n}\sum_{i=1}^n c_iX_i.
$$

不偏性を要請すると $E[\hat{\theta}]=\mu\sum_{i=1}^n c_i$ であるから $\sum_{i=1}^n c_i = 1$ が容易にわかる.
$\hat{\theta}$ の分散は次のようにしてわかる:

$$
V(\hat{\theta})=E[(\hat{\theta} - E[\hat{\theta}])^2] = E[\sum_{i=1}^n c_i(X_i - \mu)^2] = \sigma^2\sum_{i=1}^n c_i^2
$$

ここで $\sigma^2$ は一つのサンプルの分散を表す. つまり $\sum_{i=1}^n c_i = 1$ の条件のもと二乗和 $\sum_{i=1}^n c_i^2$ の極値問題を求めれば良い. それは

次のようなラグランジュ関数を偏微分しその零点を与えるようにすれば良い.

$$
L(c_1,\dots,c_n) = \sum_{i=1}^n c_i^2 - \lambda(\sum_{i=1}^n c_i - 1)
$$

そうすると $i$ によらず $c_i = \lambda/2$ となる. ということで拘束条件から $c_i = 1/n$ となる. 実は最初に計算したものが BLUE (best linear unbiased estimator) になっていることがわかる.


## 二乗誤差

良い推定量として $E[(\hat{\theta} - \theta_0)^2]$ を最小化するという方針も取れる. ただし unbiased estimator であればこれは実質 $V[\hat{\theta}]$ である. 実際下記のように分解し, クロスタームの期待値がゼロになることを利用すると

$$
\begin{aligned}
E[(\hat{\theta} - \theta_0)^2] 
&= E[(\hat{\theta} - E[\hat{\theta}] + E[\hat{\theta}] - \theta_0)^2] \\
&= E[(\hat{\theta} - E[\hat{\theta}])^2] + E[(E[\hat{\theta}] - \theta_0)^2] + 2E[(\hat{\theta} - E[\hat{\theta}])(E[\hat{\theta}] - \theta_0)]\\
&= E[(\hat{\theta} - E[\hat{\theta}])^2] + (E[\hat{\theta}] - \theta_0)^2 \\
&= V(\hat{\theta}) + (\textrm{Bias}(\hat{\theta}))^2
\end{aligned}
$$

となるからである.


# Fisher 情報量と Cramér–Rao の不等式

- ここでは(議論の簡単のため)パラメータの次元が１である場合に注目する.
- 上記の議論で, 不偏推定量の中で良いものの比較は分散の大小で決めると良さそうであることがわかった. 実は推定量の分散は Cramér–Rao の不等式によってフィッシャー情報量の逆数(= Cramér–Rao の下限)で下から抑えられることがわかっている. Fisher 情報量の定義をする.
- i.i.d なサンプルを用意してそれを $X^n$ とおく. $f(x|\theta)$ を確率モデルとし, $S_n$ を対数尤度の微分とする:

$$
\begin{aligned}
f_n(X^n|\theta) &\underset{\textrm{def}}{=} \prod_{i=1}^n f(X_i|\theta) \\
S_n(\theta, X^n) &\underset{\textrm{def}}{=} \frac{d}{d\theta} \log f_n(X^n|\theta)
\end{aligned}
$$

Fisher 情報量 $I_n(\theta)$ を次のように定義する:

$$
I_n(\theta) = E[(S_n(\theta, X^n)^2] = \int S_n(\theta, x^n)f(x|\theta) dx
$$


- パラメータが複数ある場合は $\partial_i\log f(X_1|\theta)\partial_j\log f(X_1|\theta)$ を $(i, j)$ 成分にもつ行列として $I(\theta)$ を定義する. これは Fisher 情報量行列と呼ばれる. $\partial_i$ は $i$ 番目の成分で偏微分する意味である.


## 確率モデルに要請するいくつかの仮定

#### Prop:

確率モデル $f(x|\theta)$ が次を満たしているとする:

- C1: f のサポート集合 $\{x|f(x|\theta)\neq 0\}$ が $\theta$ に依存しない.
  - `f=0` の場所は `log` によって定義できなくなるのと微分によって $\theta$ の値を色々変える処理があるから Fisher 情報量を定義できるようにするための条件？
- C2: 
  下記のように微分積分順序が可能:
  $$
  \frac{d}{d\theta}\int f(x|\theta) dx = \int \frac{d}{d\theta} f(x|\theta) dx (= 0)
  $$
  $$
  \frac{d^2}{d\theta^2}\int f(x|\theta) dx = \int \frac{d^2}{d\theta^2} f(x|\theta) dx (= 0)
  $$
- C3:
  - $0 < I_1(\theta) <\infty$ すなわち, サンプルが１のFisher情報量が定義されており可逆.
  
この時次が成り立つ:

- $E[S_1(\theta, X_1)] = 0$,
- $I_n(\theta) = n I_1(\theta)$,
- $I_1(\theta) = -E\left[\frac{d^2}{d\theta^2}\log f(X_i|\theta)\right]$.

#### Proof:

実際, $\dot{f}$ を $\theta$ に関する微分とすると 
$$
E[S_1(\theta, X_1)] = E[\frac{d}{d\theta}\log f] = \int \frac{\dot{f}}{f} f dx = \int \dot{f} dx = \frac{d}{d\theta}\int f dx = \frac{d}{d\theta} 1 = 0
$$

$$
\begin{aligned}
I_n(\theta) 
&= E[(S_n(\theta, X^n)^2] \\
&= E[(\frac{d}{d\theta}\sum_{i=1}^n \log f(X_i | \theta))^2] \\
&= E[\sum_{i=1}^n (\frac{d}{d\theta} \log f(X_i | \theta))^2] + 2 \sum_{i<j} E[\frac{d}{d\theta}\log f(X_i|\theta)]E[\frac{d}{d\theta}\log f(X_j|\theta)] \\
&=E[\sum_{i=1}^n (\frac{d}{d\theta} \log f(X_i | \theta))^2] + 0 \\
&=\sum_i E[S_1^2(\theta, X_i)] = nI_n(\theta)
\end{aligned}
$$

最後に

$$
\frac{d^2}{d\theta^2} \log f = \ddot{f}/f - (\dot{f}/f)^2
$$

に注意して
$$
E[\frac{d^2}{d\theta^2}\log f(X_i|\theta)] = \int \ddot{f} dx - E[S_1^2] = -E[S_1^2]
$$

から従う.


### Prop: Cramér–Rao の不等式

- 確率モデルが上記の C1, C2, C3 の条件を満足し, $\hat{\theta}$ が不偏推定量とする. 分散 $V(\hat{\theta})$ が存在して
$$
\frac{d}{d\theta} \int \hat{\theta}(x^n) f_n(x|\theta)dx = 
\int \frac{d}{d\theta}  \hat{\theta}(x^n) f_n(x|\theta)dx
$$

ならば

$$
V(\hat{\theta}) \geq \frac{1}{I_n(\theta)}
$$

を得る. これが Cramér–Rao の不等式である.


### 証明:

積分に関するシュワルツの不等式を利用する:

$$
\begin{aligned}
E[(\hat{\theta}(X^n) - \theta)S_n(\theta, X^n)]^2 &\leq E[(\hat{\theta}(X^n) - \theta)^2] E[S_n(\theta, X^n)^2] \\
&= E[(\hat{\theta}(X^n)-E[\hat{\theta}])]E[S_n(\theta, X^n)^2] \\
&= V(\hat{\theta}) I_n(\theta)
\end{aligned}
$$

ここで左辺は
$$
\begin{aligned}
E[(\hat{\theta}(X^n) - \theta)S_n(\theta, X^n)]
&=
E[(\hat{\theta}(X^n)S_n(\theta, X^n)] - \theta E[S_n(\theta, X^n)] \\
&= \int \hat{\theta}(x^n) \frac{d}{d\theta} f_n(x|\theta) dx - \theta E[\sum_i \frac{d}{d\theta}\log f(X_i|\theta)] \\
&= \frac{d}{d\theta}E[\hat{\theta}] - 0 = \frac{d}{d\theta} \theta = 1
\end{aligned}
$$

よって示したい不等式が得られる. ($I_n = n I_1$ であること, 0 より真に大きいことに注意する.)


#### Example

i.i.d なサンプル $X^n$, $X_i \sim \mathcal{N}(\mu, 1)$ の場合,

$$
\log f(X| \mu) = - 2^{-1} \log (2\pi) - 2^{-1}(X-\mu)^2
$$

だから

$$
\frac{d}{d\mu}\log f(X_1|\mu) = (X_1 - \mu)
$$

よって 
$$
I_1 = E[S_1(\theta, X_1)] = E[(X_1-\mu)] = V[X_1] = 1
$$
だから $I_n = n$ である.

よって平均に関するCramér–Raoの不等式は

$$
V(\hat{\mu}) \geq 1/n
$$

となる. 一方で, 

$$
\bar{X} = \frac{1}{n} \sum_{i=1}^n X_i
$$

が $\hat{\mu}$ であるときは $V(\bar{X}) = \frac{1}{n}$ である. つまり $\bar{X}$ は Cramér–Raoの下限を実現できている良い．不偏推定量になっている.


# Reference

特異モデルについての英語のレクチャーノートは例えば下記のようなものがある. (適当にググっただけなので内容については保証しない)kkk

- http://dept.stat.lsa.umich.edu/~moulib/stat612-notes2.pdf
