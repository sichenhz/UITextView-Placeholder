# UITextView-Placeholder

## Usage
``` bash
UITextView *textView = [[UITextView alloc] init];
textView.placeholder = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu";
```

or

``` bash
NSMutableParagraphStyle *paragraphM = [[NSMutableParagraphStyle alloc] init];
paragraphM = 10;
NSMutableAttributedString *attrStrM = [[NSMutableAttributedString alloc] initWithString:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu"];
[attrStrM addAttribute:NSParagraphStyleAttributeName value:paragraphM range:NSMakeRange(0, attrStrM.length)];
UITextView *textView = [[UITextView alloc] init];
textView.attributedPlaceholder = [attrStrM copy];
```

## demo
![demo](https://img.alicdn.com/imgextra/i4/135480037/TB2kM0plXXXXXaJXpXXXXXXXXXX_!!135480037.gif)

