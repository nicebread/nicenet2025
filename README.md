# nicenet 2025 website

This is the repo for my personal website. As my university moved to a new CMS (which has a terrible usability), I had to redo my publication list. I decided to use this opportunity to also update the design of my website. I used the [quarto-academic-website-template](https://github.com/drganghe/quarto-academic-website-template) by [Gang He](https://github.com/drganghe) as a starting point. 

The list of publications is heavily inspired by the examples from [Andrew Heiss](https://www.andrewheiss.com/research/) and [John Paul Helveston](https://www.jhelvy.com/research). It is dynamically created based on a list of dois and OpenAlex.

### Notes:

- Computing the Haikus with the local LLM is quite slow, so the results are cached in file `files/publist_preprocessed.xlsx`. You can delete this file to recompute the haikus.