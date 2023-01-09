const addEntry = () => {
	const createButton = document.getElementById('addEntry');
	createButton.addEventListener('click', (e) => {
		e.preventDefault();
		const newFieldset = document.querySelector('.fieldset').outerHTML
		console.log('newFieldset', newFieldset)
		document.querySelector('#field-set-container').innerHTML += newFieldset
	});
}
export { addEntry }
