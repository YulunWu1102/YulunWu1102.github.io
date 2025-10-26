---
layout: page
title: Subspace-SpatialCodec 
description: Neural Spatial Speech Coding with a Subspace-Driven Reference (2024/06 - 2024/08)
img: assets/img/SSC/SSC_chart.png
importance: 2
category: work
related_publications: false
---

We explore spatial **speech coding** for **multi-speaker, multi-mic** recordings and propose **Subspace-SpatialCodec**: a two-branch neural codec that (i) derives **two reference channels** via a **subspace method** and encodes them with mono Encodec, and (ii) learns **complex ratio filters (CRFs)** to reconstruct all array channels from the references—preserving **spatial cues** (direct path, early and late reflections) under tight bit-budgets. Compared to SpatialCodec, our design targets **multi-source** scenes by steering references with the dominant subspace of the spatial covariance. 

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/SSC/SSC_chart.png" title="Subspace-SpatialCodec Overview" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Two-branch architecture: subspace-steered references (Encodec) + SpatialCodec-style CRFs for array reconstruction.
</div>

---

### TL;DR — What’s new
- **Subspace-steered references:** Build **two** reference channels by eigen-decomposing per-bin spatial covariance, then encode with **pretrained mono Encodec (6 kbps × 2)**.  
- **Spatial branch:** Condition a **CRF decoder** on (reference STFTs ⊕ spatial covariance features) to synthesize **M channels**.  
- **Multi-speaker focus:** Designed to **scale beyond one speaker** by letting the references capture dominant steering vectors. 
---

### Problem & Setup
We code an $M$-mic mixture $x(t)=\sum_{i=1}^{N}\big[h_{i1}(t),\ldots,h_{iM}(t)\big]*s_i(t)$ into a low-bitrate code $C$ and reconstruct $\hat{x}$ that keeps **spectral quality** and **spatial structure**:
$$
\hat{x}=\Psi_{\text{Dec}}(C),\quad C=\Psi_{\text{Quant}}(\Psi_{\text{Enc}}(x)).
$$
Training uses simulated rooms (pyroomacoustics), 1–4 speakers, circular array (10 cm radius), LibriTTS at 16 kHz, 37k six-second samples. STFT: 640-pt Hann, hop 320. 

---

### Branch 1 — Two-Channel **Subspace** Reference Codec
Compute per-frequency spatial covariance:
$$
\Phi(f)=X(f)\,X(f)^{\mathrm H},\quad X(f)\in\mathbb{C}^{M\times T}.
$$
Take the top-2 eigenvectors $A\in\mathbb{C}^{M\times 2}$ and form the **steered references**:
$$
X_{\text{ref}}=A^{\mathrm H}X,\quad x_{\text{ref}}=\mathrm{ISTFT}(X_{\text{ref}}),
$$
then encode each reference with **pretrained Encodec (6 kbps)**. Motivation: provide **cleaner steering signals** for multi-source synthesis. 

---

### Branch 2 — **Subspace-SpatialCodec** (CRF Decoder)
Inputs (per TF bin):  
- Real/imag of $\Phi(t,f)$ (spatial covariance), and  
- Real/imag of reference STFTs $X_{\text{ref}}$.  

A time-freq CNN encoder compresses features to **6 sub-bands**, with **residual vector quantization**; a transpose-CNN decoder predicts **complex ratio filters** $W_m(c,t,f,l,k)$ to synthesize each array channel:
$$
\hat{X}_m(t,f)=\sum_{c=1}^{2}\sum_{l=-L}^{L}\sum_{k=-K}^{K} W_m(c,t,f,l,k)\, \hat{X}_{\text{ref}}(c,t+l,f+k).
$$
Training uses **codebook loss** + **time-domain SNR loss**; at train time the CRF applies to the **ground-truth** references to avoid branch mismatch. Typical settings: $K{=}1$, $L{=}4$, codebook size $1024$, 4 RVQ layers. 

---

### Metrics
- **Channel metrics:** SNR, PESQ, STOI; **non-intrusive:** DNSMOS (SIG/BAK/OVRL).  
- **Spatial metrics:** **RTF error** (angle between true/estimated principal RTFs) and **Spatial Similarity** via super-directive beamformer banks. Also report metrics after **beamforming** toward ground-truth DOAs. 
---

### Key Results (8-mic, 24–36 kbps total)
- With **ground-truth references**, SpatialCodec (+12 kbps) tops SNR; our **2-ref Subspace-SpatialCodec** is competitive on **PESQ/STOI** and DNSMOS.  
- With **Encodec-reconstructed references**, SpatialCodec still leads **SNR** and **STOI**; our method shows **marginal gains** in some perceptual/non-intrusive scores.  
- Takeaway: **Subspace references help** but are **not sufficient** alone to solve multi-speaker spatial coding; stronger **reference separation** and **joint ref-branch training** look promising. 

---

### Why it matters
- **Low-bitrate spatial capture** for arrays (telepresence, AR/HMD, meeting transcription) needs both **signal quality** and **spatial fidelity**.  
- Subspace-steered references are a **simple, model-agnostic** way to inject **multi-source structure** into SpatialCodec-style decoders. 

---

### Implementation Notes
- Encoder/decoder: 6 conv stages with residual units; time-dilated 2-D CNNs; frequency strides compress **321 bins → 6 sub-bands**; RVQ on sub-bands; ADAM $1\text{e}{-4}$, 100k steps, batch 8, 6 s segments.  
- Total bitrate examples: **12 kbps spatial** + **(6 kbps × refs)**. 

---

### Limitations & Next Steps
- **SNR gap** vs. SpatialCodec persists in multi-speaker scenes, especially with **reconstructed references**.  
- Future: integrate a **source separation front-end** for the reference branch and **train a dedicated reference codec** jointly to lower rate & mismatch. 
---
