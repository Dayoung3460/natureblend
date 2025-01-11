import {createI18n} from 'vue-i18n'

const messages = {}
const requireLang = import.meta.glob('@/lang/**/*.json', { eager: true })
// { eager: true }
// files should be loaded synchronously
// import.meta.glob loads files asynchronously by default and returns a Promise object.

// console.log(requireLang)
// {
//     /src/lang/en/msg.json: Module,
//     /src/lang/ko/msg.json: Module
// }


// Read JSON files
for (const path in requireLang) {
    // Extract the language ('en' or 'ko')
    const match = path.match(/\/lang\/([^/]+)\/[^/]+\.json$/)
    if (!match) continue

    const lang = match[1] // 'en' or 'ko'

    // Initialize the language object if not already set
    if (!messages[lang]) messages[lang] = {}

    // Merge JSON content
    Object.assign(messages[lang], requireLang[path].default || requireLang[path])
}

const defaultLocale = () => localStorage.getItem('lang') || 'en'

const i18n = createI18n({
    locale: defaultLocale(),
    fallbackLocale: 'en',
    messages,
    silentTranslationWarn: true
})

export default i18n