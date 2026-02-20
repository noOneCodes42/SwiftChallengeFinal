//
//  CountryOfResidence.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 8/6/25.
//

import SwiftUI

struct CountryOfResidence: View {
    var limeGreen = Color(red: 0.1803921568627451, green: 0.7490196078431373, blue: 0.5686274509803921   )
    var paleGreen = Color(red: 0.5764705882352941, green: 0.9764705882352941, blue: 0.7254901960784313)
    private var listOfCountries = [
        "Afghanistan": [],
        "Albania": [],
        "Algeria": [],
        "Andorra": [],
        "Angola": [],
        "Antigua and Barbuda": [],
        "Argentina": [],
        "Armenia": [],
        "Australia": [],
        "Austria": [],
        "Azerbaijan": [],
        "Bahamas": [],
        "Bahrain": [],
        "Bangladesh": [],
        "Barbados": [],
        "Belarus": [],
        "Belgium": [],
        "Belize": [],
        "Benin": [],
        "Bhutan": [],
        "Bolivia": [],
        "Bosnia and Herzegovina": [],
        "Botswana": [],
        "Brazil": [],
        "Brunei": [],
        "Bulgaria": [],
        "Burkina Faso": [],
        "Burundi": [],
        "Cabo Verde": [],
        "Cambodia": [],
        "Cameroon": [],
        "Canada": [],
        "Central African Republic": [],
        "Chad": [],
        "Chile": [],
        "China": [],
        "Colombia": [],
        "Comoros": [],
        "Congo (Congo-Brazzaville)": [],
        "Costa Rica": [],
        "Croatia": [],
        "Cuba": [],
        "Cyprus": [],
        "Czech Republic": [],
        "Democratic Republic of the Congo": [],
        "Denmark": [],
        "Djibouti": [],
        "Dominica": [],
        "Dominican Republic": [],
        "Ecuador": [],
        "Egypt": [],
        "El Salvador": [],
        "Equatorial Guinea": [],
        "Eritrea": [],
        "Estonia": [],
        "Eswatini": [],
        "Ethiopia": [],
        "Fiji": [],
        "Finland": [],
        "France": [],
        "Gabon": [],
        "Gambia": [],
        "Georgia": [],
        "Germany": [],
        "Ghana": [],
        "Greece": [],
        "Grenada": [],
        "Guatemala": [],
        "Guinea": [],
        "Guinea-Bissau": [],
        "Guyana": [],
        "Haiti": [],
        "Honduras": [],
        "Hungary": [],
        "Iceland": [],
        "India": [],
        "Indonesia": [],
        "Iran": [],
        "Iraq": [],
        "Ireland": [],
        "Israel": [],
        "Italy": [],
        "Ivory Coast": [],
        "Jamaica": [],
        "Japan": [],
        "Jordan": [],
        "Kazakhstan": [],
        "Kenya": [],
        "Kiribati": [],
        "Kuwait": [],
        "Kyrgyzstan": [],
        "Laos": [],
        "Latvia": [],
        "Lebanon": [],
        "Lesotho": [],
        "Liberia": [],
        "Libya": [],
        "Liechtenstein": [],
        "Lithuania": [],
        "Luxembourg": [],
        "Madagascar": [],
        "Malawi": [],
        "Malaysia": [],
        "Maldives": [],
        "Mali": [],
        "Malta": [],
        "Marshall Islands": [],
        "Mauritania": [],
        "Mauritius": [],
        "Mexico": [],
        "Micronesia": [],
        "Moldova": [],
        "Monaco": [],
        "Mongolia": [],
        "Montenegro": [],
        "Morocco": [],
        "Mozambique": [],
        "Myanmar": [],
        "Namibia": [],
        "Nauru": [],
        "Nepal": [],
        "Netherlands": [],
        "New Zealand": [],
        "Nicaragua": [],
        "Niger": [],
        "Nigeria": [],
        "North Korea": [],
        "North Macedonia": [],
        "Norway": [],
        "Oman": [],
        "Pakistan": [],
        "Palau": [],
        "Palestine": [],
        "Panama": [],
        "Papua New Guinea": [],
        "Paraguay": [],
        "Peru": [],
        "Philippines": [],
        "Poland": [],
        "Portugal": [],
        "Qatar": [],
        "Romania": [],
        "Russia": [],
        "Rwanda": [],
        "Saint Kitts and Nevis": [],
        "Saint Lucia": [],
        "Saint Vincent and the Grenadines": [],
        "Samoa": [],
        "San Marino": [],
        "Sao Tome and Principe": [],
        "Saudi Arabia": [],
        "Senegal": [],
        "Serbia": [],
        "Seychelles": [],
        "Sierra Leone": [],
        "Singapore": [],
        "Slovakia": [],
        "Slovenia": [],
        "Solomon Islands": [],
        "Somalia": [],
        "South Africa": [],
        "South Korea": [],
        "South Sudan": [],
        "Spain": [],
        "Sri Lanka": [],
        "Sudan": [],
        "Suriname": [],
        "Sweden": [],
        "Switzerland": [],
        "Syria": [],
        "Taiwan": [],
        "Tajikistan": [],
        "Tanzania": [],
        "Thailand": [],
        "Timor-Leste": [],
        "Togo": [],
        "Tonga": [],
        "Trinidad and Tobago": [],
        "Tunisia": [],
        "Turkey": [],
        "Turkmenistan": [],
        "Tuvalu": [],
        "Uganda": [],
        "Ukraine": [],
        "United Arab Emirates": [],
        "United Kingdom": [],
        "United States": [
            "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado",
            "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho",
            "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana",
            "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota",
            "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada",
            "New Hampshire", "New Jersey", "New Mexico", "New York",
            "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon",
            "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota",
            "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington",
            "West Virginia", "Wisconsin", "Wyoming"
        ],
        "Uruguay": [],
        "Uzbekistan": [],
        "Vanuatu": [],
        "Vatican City": [],
        "Venezuela": [],
        "Vietnam": [],
        "Yemen": [],
        "Zambia": [],
        "Zimbabwe": []
    ]
    @State private var userSearching = ""
    init(countryChosen: CountryChosen){
        self.countryChosen = countryChosen
    }
    var filteredItems: [String]{
        if userSearching.isEmpty{
            return listOfCountries.keys.sorted()
        } else{
            return listOfCountries.keys.sorted().filter {$0.localizedCaseInsensitiveContains(userSearching)}
        }
    }
    @FocusState private var keyBoardFocused: Bool
    @Environment(\.dismiss) var dismiss
    @ObservedObject var countryChosen: CountryChosen
    var body: some View {
        ZStack{
            ColorScheme()
            ZStack(alignment: .topLeading){
                VStack{
                    HStack{
                        Spacer()
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                            .fontWeight(.heavy)
                            .onTapGesture {
                                dismiss()
                            }
                    }
                    Spacer()
                }
                .padding()
            }
            
            VStack(){
                Text("Countries")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.bottom, 25)
                    .padding(.top, 30)
                    .font(.title2)
                HStack{
                    
                    TextField("Search", text: $userSearching)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 300, height: 100)
                        .cornerRadius(12)
                        .focused($keyBoardFocused)
                        .colorScheme(.light)
                    
                    
                }
                ZStack{
                    ScrollView{
                        ForEach(filteredItems, id: \.self){ countries in
                            Text(countries)
                                .foregroundStyle(.white)
                                .fontWeight(.medium)
                                .padding(.leading, 30)
                                .padding(.bottom, 5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onTapGesture{
                                    countryChosen.text = countries
                                    dismiss()
                                }
                                .onSubmit{
                                    keyBoardFocused = false
                                }

                            
                        }
                        
                    }

                }
                
            }
        }
        .onTapGesture {
            keyBoardFocused = false
        }
        
    }
}
class CountryChosen: ObservableObject{
    @Published var text = ""
}

#Preview {
    CountryOfResidence(countryChosen: CountryChosen())
}
