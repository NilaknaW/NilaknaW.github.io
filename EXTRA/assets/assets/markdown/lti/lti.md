# Analysing LTI: A Study on Linear Time Invarient Systems

_Nilakna D. Warushavithana_  
_June 2, 2024_

Read PDF here: [LINK](https://github.com/NilaknaW/signals/blob/main/Documents/1_LTI.pdf)
---

## Introduction

In the analysis of signals and systems, linear time invarient systems (LTI) allows understanding of many systems in the world and extends beyond by approximating complex systems. This article looks into different methods of analysing LTI and mathematical tools we use to simplify the process.

## LTI Systems - Linear Time Invarient Systems

### Properties

A system in general is simply a *input - process - output* model with different propoerties. Let $x(t)$ be the input to our system and $y(t)$ be the system output. [fig. \ref{sys}] In signals and systems context, we refer to the input as `signal` and the output as `response`. Usually we take time `t` as the variable but it can be of any choice.

Now, let's understand what LTI is. LTI system has two properties, namely linearity and time invarience. A system is linear if the following property holds true for any input x(t).

Let $x_1 (t)$ and $x_2 (t)$ be inputs to the system and $y_1(t) $ and $y_2(t)$ be outputs or system reponses to the inputs.  
\[  x_1 (t) \longrightarrow y_1 (t) \]  
\[ x_2 (t) \longrightarrow y_2 (t) \]  
If the weighted sum of individual inputs result in the weighted sum of individual responses, we call the system linear. i.e. if,  
\[x_1 (t)+ x_2 (t) \longrightarrow y_1 (t)+y_2 (t) \Longrightarrow Linear\]  

More generally,  
\[\sum{a_i x_i (t)} \longrightarrow \sum{a_i y_i (t)}\Longrightarrow Linear \]  

Essentially, if the input is zero, output is also zero, for linear systems; hence called zero in - zero out propoerty as well. For example $y(t) = x(t) + 3$ is non-linear and it can be clearly identified by giving a zero input and checking the output.

If the system response does not change with time, it it called a time invarient system. In other words, time invarience property tells that a time shift in the input results in an identical time shift in the output [^1]: for a time shift $t_0$, the time input $x(t -t_0)$ gives the same output as $y(t-t_0)$. This is satisfied if the response depends on t inderectly only through x(t).  
\[y(t) = f(x(t),t) = f(x(t))\]  

For example, $y(t) = sin(x(t))$ is a time invarient system because $y(t-t_0) = sin(x(t-t_0))$. Conversely, $y(t) = t sin(x(t))$ is time varying since $y(t-t_0) \neq t sin(x(t-t_0)) $.

Sytems with both propoerties linarity and time invarience are called Linear Time-Invarient systems, in short, LTI systems, and we will continue out study on analysing them.

### Characterizing

To analysie LTI we first need to characterize the system. By characterizing it means to find a system function/ transfer function which represents what a system does to any input. The characterising function should be able to capture a large class of signals and simple enough to do calculations. Examples for such fundamental functions are impulse function, unit step function, and complex exponential function.

#### Impulse Response and Convolution

We can represent any signal as a convolution with the impulse function as follows for continuous time (CT) and discrete time (DT).  
\[x(t)*\delta(t) = \int\limits_{-\infty}^{+\infty} x(\tau) \delta(t-\tau) d \tau =\int\limits_{-\infty}^{+\infty} x(t) \delta(t-\tau) d\tau = x(t) \int\limits_{-\infty}^{+\infty} \delta(t-\tau) d\tau = x(t) \cdot 1 = x(t) \]  
\[x[n]*\delta[n] =\sum_{k=-\infty}^{+\infty} x[k] \delta[n-k] =\sum_{k=-\infty}^{+\infty} x[n] \delta[n-k] = x[n]\sum_{k=-\infty}^{+\infty} \delta[n-k] = x[n]\cdot 1 = x[n] \]  

Let the system response to an impulse be h[n].  
\[\delta[n] \xrightarrow{LTI} h[n]\]  

For each k fixed, x[k] is also fixed and acts as a scaling factor to $x[k]\delta_n[k]$. Because of time invarience, we can write $\delta_n[k] = \delta[n-k]$.  
\[\forall k \in \mathbb{Z},\ \ x[k]\delta[n-k] \xrightarrow{LTI} x[k]h[n-k]\]  
Due to linearity, when we take the sum of weighted impulses over all k, the output is the weighted sum of impulse response over all k.  
\[...+x[-1]\delta[n+1]+x[0]\delta[n]+x[1]\delta[n-1]+...  \xrightarrow{LTI} ...+x[-1]h[n+1]+x[0]h[n]+x[1]h[n-1]+... \]  
\[\sum^{+\infty}_{k=-\infty}x[k]\delta[n-k]  \xrightarrow{LTI} \sum^{+\infty}_{k=-\infty}x[k]h[n-k]\]  

Similarly, for continuous time,  
\[\int^{+\infty}_{-\infty} x(t) \delta(t-\tau) d\tau  \xrightarrow{LTI} \int^{+\infty}_{-\infty} x(t) h(t-\tau) d\tau\]  

We can summerise the LTI system reponses for CT and DT using convolution with impulse response as follows. So, if we know the impulse response of a system we can find system reponse (output) to any input. Hence, the impulse response characterizes the system.

---

[^1]: Oppenheim, A. V., & Willsky, A. S. (1997). *Signals and Systems* (2nd ed.). Prentice-Hall.
