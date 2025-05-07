# A deep dive into Continous Time Signals

### The big picture: what is $a_k$, $X(\omega)$, $X(s)$ ?

_April 8, 2024_

View PDF: [Link](https://github.com/NilaknaW/signals/blob/main/Documents/2_CT.pdf) 

## Equations: Fourier Series, Fourier Transform, and Laplace Transform

...

1. **Fourier Series: Synthesis**
   $$
   x(t) = \sum_{k = -\infty}^{+\infty} a_k e^{jk\omega _0 t}
   $$

2. **Fourier Series: Analysis**
   $$
   a_k = \frac{1}{T} \int_{T} x(t) e^{-jk\omega _0 t} dt
   $$

3. **Fourier Transform: Synthesis**
   $$
   x(t) = \frac{1}{2\pi} \int_{-\infty}^{+\infty} X(j\omega) e^{j\omega t} d\omega
   $$

4. **Fourier Transform: Analysis**
   $$
   X(j\omega) = \int_{-\infty}^{+\infty} x(t) e^{-j\omega t} dt
   $$

5. **Laplace Transform: Synthesis**
   $$
   x(t) = \frac{1}{2\pi j} \int_{\sigma-j\infty}^{\sigma+j\infty} X(s) e^{st} ds
   $$

6. **Laplace Transform: Analysis**
   $$
   X(s) =  \int_{0}^{\infty} x(t) e^{- st}dt 
   $$
   where $s=\sigma+j\omega$.

## Comparison: What are the differences among these methods?

| **Feature** | **Fourier Series (FS)** | **Fourier Transform (FT)** | **Laplace Transform (LT)** |
|------------|-------------------------|----------------------------|-----------------------------|
| Type of signal | Can be applied to periodic and both continous or descrete time signals. | Can be applied to periodic and aperiodic, stable, continous time, convergent, and finite energy signals. A generalization of Fourier Series and a special case of Laplace transform where $\sigma=0$. | Can be applied to both periodic or aperiodic, both stable and unstable systems, converging and diverging, but continous time signals. A more generalized version of Fourier transform. Its discrete counterpart is Z-transform. |
| Nature of the transformed domain | Transformed domain is the descrete frequency domain. Magnitutes of the transformed coefficients occur at integer multiples of the fundamental frequency $\omega _0$, $k\omega _0$ where $k \in \mathbb{Z}$ | Transformed domain is the continous frequency domain. Since the signal is aperiodic every frequncy component contributes to build the input signal. | Transformed domain is the complex frequency domain \cite{kareem} which includes both sinusoidal and exponential components to accomodate unstable systems. |
| Nature of the input domain | Input signal should be defined on a finite interval in time domain. | Input signal can be defined on any interval in time domain, including infinite interval allowing analysis of aperiodic signals. | Input signal can be defined on any interval including infinite interval in time domain. |
| Composition | Signal is represented as an infintie sum of scaled and shifted sines and cosines (complex exponentials). These fundamental building blocks make an orthonormal basis of trigonometric functions. | Signal is represented as an integral of scaled and shifted sinusoids (complex exponentials). It is an integral transformation. | Signal is represented by combination of scaled and shifted sinusoids and real exponentials within the Region of Convergence (ROC). Because of the use of real exponentials, LT can transform unstable signals to frequency domain [fig.  \ref{fig:unstable}]. |
| Equation interconnection | $a_k = \frac{X(jk\omega _0)}{T} = \frac{X(s =0+jk\omega _0)}{T} $ | $X(j\omega)=Ta_k = X(s =0+j\omega)$ | $X(s)$ |
| Transformation nature \cite{kareem} |  | Does a complex transformation on real data. | Does a real transformation on complex data. |


![600 Time domain signal](assets/markdown/ctsignal/res/xt-2.png)  
![600 Laplace transform](assets/markdown/ctsignal/res/lt-2.png)  
**Figure**: Laplace transform on a signal $x(t)=e^{-3t}\cos(5t)$

## Connection: Thoughts on *All these methods are different ways to scan x(t), and decompose it into frequencies.*

**Laplace Transform and Fourier Transform**

Laplace Transform is the most general case of all three methods. LT can analyse periodic and aperiodic, stable and unstable, and converging and diverging signals which are continuous time. LT transforms from time domain to the complex frequency domain with real axis $\sigma$ and imaginary axis $i\omega$. $\sigma$ is responsible for adding real exponential component to the signal and $i\omega$ for detailing the sinusoidal characteristics. 

Consider a continous time periodic signal $x(t)=\cos(5t)+2\sin(3t)$ [fig. \ref{fig:xt1}] and its laplace transform $X(s) = \frac{s}{s^2 + 25} + \frac{6}{s^2 + 9}$ [fig. \ref{fig:lt1}]. Note the poles at $i\omega= 3 \ and\  i\omega= 5$. Since the poles lie on $\sigma=0$ we can say that the signal is composed of purely sinuosoidal components, as in $x(t)$.

![600 Time domain signal $x(t)$](assets/markdown/ctsignal/res/xt-1.png)  
**Figure**: Time domain signal $x(t)$

![600 Laplace Transform of $x(t)$](assets/markdown/ctsignal/res/lt-1.png)  
**Figure**: Laplace Transform of $x(t)$

Continous Time Fourier Transform is when $\sigma=0$ in Laplace Transform, in other terms, when s of LT is purely imaginary, which is equal to having only sinusoidal components as discussed in FT itself. So FT is a slice from the LT along the imaginary axis $j\omega$. In our example the FT is $X(i\omega)= \pi(\delta(w - 5) + \delta(w + 5)) - i2\pi(\delta(w - 3) - \delta(w + 3))$ LT sliced at $\sigma=0$ [fig. \ref{fig:ft1}]

![600 Fourier Transform of x(t) by slicing the Laplace Transform at $\sigma = 0$](assets/markdown/ctsignal/res/ft-1.png)  
**Figure**: Fourier Transform of x(t) by slicing the Laplace Transform at $\sigma = 0$

However, any slice of fixed $\sigma$ in LT gives a corresponding fourier transform, if it is defined on the domain. In other terms, LT of a signal can be obtained from the FT of the signal multiplied by the real exponential function; $x(t)e^{-\sigma t}$.

$$
X(s) =  \int_{0}^{\infty} x(t) e^{-st}dt 
=  \int_{0}^{\infty} (x(t) e^{-\sigma t}) e^{-j\omega t} dt 
= \int_{0}^{\infty} \hat{x}(t) e^{-j\omega t} dt 
$$

**Fourier Transform and Fourier Series**

Fourier series is a special case of Fourier Transform where the signal is defined on a finite inteval. Because of that and the periodicity, finite number of frequency components are sufficient to represent the signal. The smallest frequency is considered the fundamental frequency $\omega _0$ and the signal composed of only the integer multiples of the fundamental as $k\omega _0$. 

From here, we can return to Fourier Transform again. Since aperiodic signal has no repetitive components, to represent the signal fully, many frequency components are needed. Going from the same analogy, the fundamental frequency will be very small so that all these components to be an integer multiple of the fundamental. Ideally, $k\omega _0$ can be now represented as $\omega$ which accomodates almost all the frequencies in the frequency domain. Now the frequency domain is continous in FT unlike the discrete domain in FS. 

This can be visualized as the following too. Since $T=\frac{2\pi}{\omega}$, when we consider aperiodicity, we essentialy increase T to infinity, making $\omega$ infinitisemly small. Again, the freqency domain of the transformation will be continous as expected in FT.

**Fourier Series and Laplace Transform**

FS can also be viewed as sampling from the FT at integer multiples of $\omega _0$ and also as sampling from the LT at integer multiples of $\omega _0$ at $\sigma = 0$.

Overall, from FS, to FT, to LT the generalization of the signal increases and the compatible domain expands.

*Footnote*: Graphs are created with matlab by the author

## Intuition: Fourier Series, Fourier Transform, and Laplace Transform

Consider a signal $x(t)$ with frequency f and period T. Then we take a sample of size $t_0$ from the signal and wrap around in complex plane. We can do this by multiplying the sample by a rotating vector $e^{-j\omega _0t}$ where $\omega _0 = 2\pi /t_0$. The resulting function is $g(t) = x(t)e^{-j\omega _0t}$. [fig. 1] \cite{3b1b-fs}.

Then we find the center of mass of the resulting graph and plot its x-coodinate varying k and the widing frequency as $k\omega _0$ [fig. 2]. When $T=t_0/k$ the COM is the furthest from the center and results in a peak in the new graph. The COM can be showed as $\frac{1}{T} \int_{T}g(t) dt$ which we denote as $a_k = \frac{1}{T} \int_{T}x(t)e^{-jk\omega _0t} dt$. This is the FS coefficient we found earlier.

![600 Wrapping up a signal by a rotating vector](assets/markdown/ctsignal/res/winding-1.jpeg)  
*Figure 1: Wrapping up a signal by a rotating vector*

![600 Plotting the Center of Mass of the wrapped up signals](assets/markdown/ctsignal/res/winding-samples.jpeg)  
*Figure 2: Plotting the Center of Mass of the wrapped up signals*

*Figure: Visualizing winding frequency ideas \cite{3b1b-ft}.*

As discussed the FT can be obtained by multiplying $a_k$ by T and increasing T to infinity which makes k very small such that we can consider $k\omega _0$ as a variable $\omega$. $X(j\omega) =\int_{-\infty}^{\infty} x(t)e^{-j\omega t} dt$. This is the same as wrapping up the whole signal by a rotating vector and taking the sum of all x-coordinates (unlike the average taken in FS) of the wrapped up graph and plotting against each winding frequency, resulting in the fourier transform of the function. Note the winding frequencies are integer multiples of the fundamental in FS but continous in FT.
