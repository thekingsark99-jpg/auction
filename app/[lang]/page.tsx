type LanguagePageProps = {
  params: { lang: string }
};

export default function Page({ params }: LanguagePageProps) {
  return (
    <main>
      <h1>Language: {params.lang}</h1>
    </main>
  );
}

export function generateStaticParams() {
  return [
    { lang: 'en' },
    { lang: 'fr' },
    { lang: 'es' }
  ];
}
