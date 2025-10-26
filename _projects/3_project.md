---
layout: page
title: OracleBeam
description: Improvements & Ablations on Subspace Hybrid-MVDR (2024/04 - 2024-06)
img: assets/img/OracleBeam/Inter_freq.png
importance: 2
category: work
related_publications: false
---

We revisit **hybrid-MVDR** beamforming and propose three add-ons—**Mask-Hybrid-MVDR**, **Sub-band Inter-Method PCA**, and **Inter-Frequency PCA**—to reduce musical noise from per-TF beamformer switching while preserving speech and spatial cues. Experiments on the **SPEAR/EasyCom** smart-glasses array show **sub-band Inter-Method PCA** consistently outperforms iso-MVDR, hybrid-MVDR, and wide-band subspace baselines in SI-SDR/SDR/PESQ, with clearer spectrograms and lower noise floors. 

<div class="row justify-content-sm-center">
    <div class="col-sm-8 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/OracleBeam/PCA_wide.png" title="Wide-band PCA" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm-4 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/OracleBeam/beamforming.png" title="Beamforming" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    From left to right: (a) Wide-band PCA; (b) Beamforming; 
</div>


<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/OracleBeam/subspace_hybrid.png" title="Subspace Hybrid-MVDR" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    Subspace Hybrid-MVDR
</div>


### Background
**MVDR** minimizes output power with a distortionless constraint $$\mathbf{w}^H\mathbf{d}(\theta)=1 $ using a noise covariance $ \mathbf{R} $:

$$
\mathbf{w}(f)=\frac{\mathbf{R}^{-1}(f)\mathbf{d}(\theta)}{\mathbf{d}^H(\theta)\mathbf{R}^{-1}(f)\mathbf{d}(\theta)}.
$$

**Hybrid-MVDR** builds a small dictionary of $ \mathbf{R} $ (isotropic, anisotropic diffuse, plane-wave, white), applies each MVDR per TF bin, and selects the **minimum-energy** output; this denoises aggressively but induces **musical noise** from rapid switching. **Subspace Hybrid-MVDR** then applies **Inter-Method PCA** to (iso, hybrid) outputs to smooth artifacts. 

### Our Add-ons
<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/OracleBeam/mask.png" title="Mask Hybrid-MVDR" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/OracleBeam/PCA_subband.png" title="Subband PCA" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/OracleBeam/Inter_freq.png" title="Frequency Subspace Hybrid-MVDR" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    From left to right: Subspace Hybrid-MVDR, Mask Hybrid-MVDR, and Frequency Subspace Hybrid-MVDR
</div>

- **Mask-Hybrid-MVDR.** Treat the hybrid output as a rough speech estimate → derive **speech-presence mask** → update steering vector and NCM adaptively → run **adaptive MVDR** to mitigate non-linear musical distortion. 
- **Sub-band Inter-Method PCA.** Replace wide-band PCA with **per-band PCA** over $K$ equal-width frequency groups: $ Z=[Z_1,\dots,Z_K],\; Z_i\in\mathbb{C}^{2\times F/K} $. This respects frequency-dependent beam patterns and SNR, improving high-band preservation.
- **Inter-Frequency PCA.** Treat the **frequency axis as the signal space** and beamformer variants as samples $(M{+}1)\times F$, promoting spectral coherence; included as an ablation. 

### Dataset & Setup
We use **SPEAR** (EASYCOM subset): meetings with up to 3 concurrent talkers, **smart-glasses 6-mic array**, plus 10 loudspeakers emitting diffuse noise. Ground-truth DOAs provided from on-device cameras. Metrics: **PESQ**, **SDR**, **SI-SDR**. 


<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/OracleBeam/SDR.png" title="Mask Hybrid-MVDR" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/OracleBeam/SI-SDR.png" title="Subspace Hybrid-MVDR" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/OracleBeam/PESQ.png" title="Frequency Subspace Hybrid-MVDR" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    From left to right: Evaluations of SDR, SI-SDR, and PESQ among different methods
</div>



### Key Findings
- **Sub-band PCA > Wide-band PCA.** Per-band processing **reduces musical noise** and **retains high-freq speech energy** better than wide-band PCA that overfits low-freq energy. 
- **Hybrid-MVDR** excels at **aggressive denoising** but needs post-smoothing; PCA modules provide that smoothing. 
- **Inter-Frequency PCA** lags due to strong **cross-frequency noise correlation**, limiting separability when frequencies are treated as the feature space. 
- **Mask-MVDR** can help in principle, but gains are **mask-quality limited** when the hybrid estimate is not clean enough to seed robust masks.

### Spectrograms (Qualitative)

<div class="row">
    <div class="col-sm mt-5 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/OracleBeam/Noisy.png" title="Noisy" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm mt-5 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/OracleBeam/ISO-MVDR.png" title="Iso-MVDR" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm mt-5 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/OracleBeam/Hybrid-MVDR (minimum energy).png" title="Hybrid MVDR" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm mt-5 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/OracleBeam/Inter-method_PCA_Wideband.png" title="Inter-method PCA (Wideband)" class="img-fluid rounded z-depth-1" %}
    </div> 
    <div class="col-sm mt-5 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/OracleBeam/Inter-method_PCA_Subband_.png" title="Inter-method PCA (4 Subbands)" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    Spectrum comparison (from left to right): (a) noisy speech; (b) isomorphic MVDR; (c) hybrid MVDR; (d) inter-method PCA (Wideband); (d) inter-method PCA (4 subbands)
</div>

### Takeaways
- **Practical recipe:** run a small **NCM dictionary** (iso + a few anisotropic/plane-wave models) → **hybrid min-energy selection** → **sub-band PCA** (e.g., $K{=}8$–16).  
- **When to skip:** if masks are unreliable or latency is tight, **avoid mask-MVDR**; prefer **sub-band PCA** for stable gains. 

### References
Project report: OracleBeam — *Improvement and Ablations on Subspace Hybrid-MVDR*. UIUC ECE 513 Final Report. 
