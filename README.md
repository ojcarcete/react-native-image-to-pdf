
# react-native-image-to-pdf

Create a PDF by an Array of images in React-Native.

## Getting started

`$ npm install react-native-image-to-pdf --save`

or

`$ yarn add react-native-image-to-pdf`
### Mostly automatic installation

`$ react-native link react-native-image-to-pdf`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-image-to-pdf` and add `RNImageToPdf.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNImageToPdf.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import RNImageToPDF.RNImageToPdfPackage;` to the imports at the top of the file
  - Add `new RNImageToPdfPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-image-to-pdf'
  	project(':react-native-image-to-pdf').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-image-to-pdf/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-image-to-pdf')
  	```


## Usage
```javascript
import RNImageToPdf from 'react-native-image-to-pdf';

...
const myAsyncPDFFunction = async () => {
	try {
		const pdf = await RNImageToPdf.createPDFbyImages({ imagePaths: ['/path/to/image1.png','/path/to/image2.png'], name: 'PDFName', forceSinglePage: false });
	} catch(e) {
		console.log(e);
	}
}
```
  