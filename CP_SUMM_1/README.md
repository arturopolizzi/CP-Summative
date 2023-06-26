# TfL Seat Pattern Generator
### Small Project 1: Generative Vector Abstraction

This Processing sketch creates a pattern inspired by the woven moquette used on the seats of the legendary Routemaster bus.

## How to use

Press play to run the sketch and generate a pattern. Press number keys 1-6 to change the pattern's colour scheme.

## Inspiration

My main source for this project is Andrew Martin's book, *Seats of London: A Field Guide to London Transport Moquette Patterns*. I have always admired the contributions of craftspeople and designers to the visual language of our everyday lives. Nothing exemplifies this better than the tufted patterns featured on the seats we sit on while moving around the city, subtle pieces of ornamentation that are ever-present but seldom noticed, and hardly credited. Rather than focus on an acclaimed auteur painter or designer, I chose to highlight the practice of TfL seat pattern-making as a whole, a craft incrementally developed by many contributors over decades.

The Routemaster pattern which served as the direct inspiration for my project was created by industrial designer Douglas Scott in the 1950s. Here it is:

![routemaster moq]([https://github.com/arturopolizzi/CM-Summative/assets/118212728/d64ef977-38a1-4662-9d53-bcfa0d7653e7](https://www.ltmuseum.co.uk/system/files/styles/collection_item_component_600_px_wide/private/collection_item/i0000im5_1.jpg?itok=F8nX0TQF)https://www.ltmuseum.co.uk/system/files/styles/collection_item_component_600_px_wide/private/collection_item/i0000im5_1.jpg?itok=F8nX0TQF)

## Notes on process

I began by faithfully recreating the precise Routemaster pattern, getting a sense of a generalised process I could abstract for use in a generative version. I then changed the inputs so that instead of being fed a specific sequence of lengths and colours to make the horizontal stripes, it would begin by generating these randomly, picking from a standard set of stripe lengths and colours. I made sure that this sequence of stripes was always scaled to fill the entire canvas perfectly, and then added horizontal separator stripes in bold yellow which separated the horizontal stripes a random number of times. I created multiple possible colour schemes that could be selected using the number keys and that would then be fed into the already-generated pattern sequence, meaning the same pattern could be shown in different colours. Finally, I added an alternating offset which took the pattern and translated it by a certain amount in the space between each separator.

A screengrab of the output can be found in the repository folder for this project.
