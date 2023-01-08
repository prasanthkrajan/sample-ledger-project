const addEntry = () => {
	const createButton = document.getElementById('addEntry');
	createButton.addEventListener('click', (e) => {
		e.preventDefault();
		const newFieldset = document.querySelector('.fieldset').outerHTML
		console.log('newFieldset', newFieldset)
		document.querySelector('#fieldsetContainer').innerHTML += newFieldset
	});
}
export { addEntry }
