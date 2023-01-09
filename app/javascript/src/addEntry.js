const addEntry = () => {
	const createButton = document.getElementById('addEntry');
	createButton.addEventListener('click', (e) => {
		e.preventDefault();
		const lastId = document.querySelector('#field-set-container').lastElementChild.id;
		const newId = parseInt(lastId, 10) + 1;
		const newFieldset = document.querySelector('[id="0"]').outerHTML.replace(/0/g,newId);
		document.querySelector('#field-set-container').insertAdjacentHTML(
			"beforeend", newFieldset
    );
	});
}
export { addEntry }
