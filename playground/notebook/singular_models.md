---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.11.3
  kernelspec:
    display_name: Julia 1.6.1
    language: julia
    name: julia-1.6
---

# 特異モデルの例


$$
\begin{aligned}
\phi_\mu(x) &= \frac{1}{(2\pi)^{1/2}} \exp\left(-\frac{1}{2}(x-\mu)^2\right), \\
\phi(x) &= \phi_{\mu=1}(x)
\end{aligned}
$$

とおく. これは正規分布 $\mathcal{N}(\mu, 1)$ に対応する確率密度関数である.
確率モデル $f$ を次のような混合モデルとする.

$$
f(x|\theta) = f(x|c,\mu) = c \phi_\mu(x) + (1-c)\phi(x)
$$

ここで $\theta=(c,\mu) \in [0,1]\times \mathbb{R}$ である.

このモデルは識別不能な確率モデルである. 実際に, $(c, \mu)$ を空間の要素として見ると $c$ 軸と $\mu$ 軸の上にある点 $\theta$ は同一の分布
を与える．　(実際には標準正規分布になる)

ここで， Dash のデモを見せる.


ところで

$$
\frac{\partial}{\partial\mu}\phi_\mu(x) = (x-\mu)\phi_\mu(x)
$$

から

$$
\begin{aligned}
\frac{\partial}{\partial \mu} \log f &= \frac{c(x-\mu)\phi_\mu}{f} \\
\frac{\partial}{\partial c} \log f &= \frac{\phi_\mu(x) - \phi(x)}{f}
\end{aligned}
$$

を得る.

いま, 真のパラメータが　$\theta_0=(c_0, \mu=0), c_0\in [0,1]$ だとする. $a_1 = 0, a_2 = 1$ とおくと

$$
a_1\frac{\partial}{\partial \mu} \log f + a_2 \frac{\partial}{\partial c} \log f =
\frac{1}{f}\left(a_1c(x-\mu)\phi_\mu(x) + a_2\phi_{\mu=0}(x)-a_2\phi(x)\right) = 0
$$

となる. つまり $\xi_1 = \frac{\partial}{\partial \mu}\log f$, $\xi_2 = \frac{\partial}{\partial c}\log f$ とおくと,

$$
a_1\xi_1 + a_2\xi_2 = 0 \\
$$

ならば

$$
\begin{aligned}
[a_1, a_2]\begin{bmatrix}\xi_1\\ \xi_2\end{bmatrix}[\xi_1, \xi_2]\begin{bmatrix}a_1\\a_2\end{bmatrix} =0 \\
\Rightarrow [a_1, a_2]\begin{bmatrix} \xi_1^2 & \xi_1\xi_2 \\ \xi_2\xi_1 & \xi_2^2\end{bmatrix}\begin{bmatrix}a_1\\a_2\end{bmatrix} =0 \\
\Rightarrow [a_1, a_2]I(\theta_0)\begin{bmatrix}a_1\\a_2\end{bmatrix} = 0
\end{aligned}
$$

つまりフィッシャー情報量行列　$I(\theta_0)$ が退化してしまう.つまり逆行列が取れなくなるので漸近有効の議論が破綻する.
