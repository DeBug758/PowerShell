# First task

**Create a function that will get a string and one of several switch parameters and return the text from string with the color passed with switch parameter.**

## Example 1
```
Write-ColoredMessage -Text "Hello there!" -Red

# Returns

Hello there!
```
## Example 2
```
Write-ColoredMessage -Text "Hello there!" -Blue

# Returns

Hello there!
```
# Second task

**Create a function that will get any array from the pipeline. Function output should be formatted according to the example below**

## Example 1
```
1..3 | Get-ValueFromPipe

# Returns

Value from pipe: 1

Value from pipe: 2

Value from pipe: 3
```
 

## Example 2
```
@("First", "Second") | Get-ValueFromPipe

# Returns

Value from pipe: First

Value from pipe: Second
```
