let jsonData = `[
    {"Name": "Arogya Kalpadruma", "Color": "1"},
    {"Name": "Kumara Tantram", "Color": "2"},
    {"Name": "Arya Bhikshak", "Color": "3"},
    {"Name": "Charaka Samhita", "Color": "4"},
    {"Name": "Ashtanga Samgraha", "Color": "5"},
    {"Name": "Ayurveda Prakash", "Color": "6"},
    {"Name": "Bhaishajaya", "Color": "7"},
    {"Name": "Brihat Bhaishajya Ratnakara", "Color": "8"},
    {"Name": "Bhava Prakasha", "Color": "9"},
    {"Name":"तनय " , "color":"8"}
  ]`
  
  let data = JSON.parse(jsonData)
  
  function search_animal() {
    let input = document.getElementById('searchbar').value
    input = input.toLowerCase();
    let x = document.querySelector('#list-holder');
    x.innerHTML = ""
  
    for (i = 0; i < data.length; i++) {
      let obj = data[i];
  
      if (obj.Name.toLowerCase().includes(input)) {
        const elem = document.createElement("li")
        elem.innerHTML = `${obj.Name} - ${obj.Color}`
        x.appendChild(elem)
      }
    }
  }