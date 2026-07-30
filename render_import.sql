--
-- PostgreSQL database dump
--

\restrict mL45HrZxFSnilFbfNPyfGMcvq1DRuJXsvIFfVBLVOfjyPg5Xd010VJ2yeTIaevF

-- Dumped from database version 16.14
-- Dumped by pg_dump version 16.14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: scheme_benefits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scheme_benefits (
    id integer NOT NULL,
    scheme_id integer,
    benefit_type character varying(100),
    benefit_value text
);


--
-- Name: scheme_benefits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scheme_benefits_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scheme_benefits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scheme_benefits_id_seq OWNED BY public.scheme_benefits.id;


--
-- Name: scheme_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scheme_documents (
    id integer NOT NULL,
    scheme_id integer,
    document_name text,
    is_mandatory boolean DEFAULT true
);


--
-- Name: scheme_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scheme_documents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scheme_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scheme_documents_id_seq OWNED BY public.scheme_documents.id;


--
-- Name: scheme_eligibility; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scheme_eligibility (
    id integer NOT NULL,
    scheme_id integer,
    rule_type character varying(100),
    rule_value text
);


--
-- Name: scheme_eligibility_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scheme_eligibility_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scheme_eligibility_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scheme_eligibility_id_seq OWNED BY public.scheme_eligibility.id;


--
-- Name: scheme_faqs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scheme_faqs (
    id integer NOT NULL,
    scheme_id integer,
    question text,
    answer text
);


--
-- Name: scheme_faqs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scheme_faqs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scheme_faqs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scheme_faqs_id_seq OWNED BY public.scheme_faqs.id;


--
-- Name: schemes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schemes (
    id integer NOT NULL,
    name character varying(300) NOT NULL,
    description text,
    apply_how text,
    deadline text,
    rejection_reasons text,
    source_url text,
    last_updated timestamp without time zone DEFAULT now(),
    application_status text DEFAULT 'unknown'::text
);


--
-- Name: schemes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schemes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schemes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schemes_id_seq OWNED BY public.schemes.id;


--
-- Name: scrape_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scrape_log (
    id integer NOT NULL,
    scheme_id integer,
    scraped_at timestamp without time zone DEFAULT now(),
    status character varying(50),
    changes_found text
);


--
-- Name: scrape_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scrape_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scrape_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scrape_log_id_seq OWNED BY public.scrape_log.id;


--
-- Name: scheme_benefits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheme_benefits ALTER COLUMN id SET DEFAULT nextval('public.scheme_benefits_id_seq'::regclass);


--
-- Name: scheme_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheme_documents ALTER COLUMN id SET DEFAULT nextval('public.scheme_documents_id_seq'::regclass);


--
-- Name: scheme_eligibility id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheme_eligibility ALTER COLUMN id SET DEFAULT nextval('public.scheme_eligibility_id_seq'::regclass);


--
-- Name: scheme_faqs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheme_faqs ALTER COLUMN id SET DEFAULT nextval('public.scheme_faqs_id_seq'::regclass);


--
-- Name: schemes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schemes ALTER COLUMN id SET DEFAULT nextval('public.schemes_id_seq'::regclass);


--
-- Name: scrape_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scrape_log ALTER COLUMN id SET DEFAULT nextval('public.scrape_log_id_seq'::regclass);


--
-- Data for Name: scheme_benefits; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.scheme_benefits (id, scheme_id, benefit_type, benefit_value) FROM stdin;
42	47	general	Up to 70% of project cost supported\nEnhanced subsidy of up to 80% (₹8 lakhs) for Persons with Disability (PwD) applicants\n₹50,000 grant per room (up to ₹2 lakhs) for upgradation of existing homestays\nCredit linkage through partner banks (Meghalaya Rural Bank and others notified)\nCollateral-free loans with 1-year moratorium: subsidy disbursed as EMI support over 24 months\nDesign and architectural support provided by empanelled firms (cost borne by Department of Tourism)\nCapacity building and training programs on hospitality, housekeeping, culinary skills, and marketing, conducted by Tourism Department and partners (MSSDS, IHM Shillong, FCI Tura)\nExposure visits for high-performing beneficiaries to learn best practices\nMandatory furnishing and solar panel support (₹1 lakh allocation per homestay included in project cost)\nIntegration with digital platforms (M-TIME portal, Meghalaya Tourist App) for booking, branding and performance tracking
43	48	general	50% of on-road vehicle cost supported (5% by entrepreneur, 45% by Government of Meghalaya)\n5% EMI co-payment support for 12 months (conditional on minimum 1500 km/month  traffic compliance)\nCredit linkage through partnered banks (MRB, MCAB, SBI, Shillong Co-operative Urban Bank)\nBranding cost of vehicle borne by Government (one-time)\nWaiver of registration charges up to ₹1 lakh under Meghalaya Vehicle Scrappage Policy 2025\nRebate on motor vehicle tax up to 15% for scrapping old diesel/petrol taxis\nTotal maximum subsidy capped at ₹5,00,000 per vehicle\nEMI subsidy provided monthly for one year based on usage and compliance
44	49	general	Financial/Monetary Support\na) 35% of the project cost as down payment paid directly by the Government to the Bank.\nb) 5% of the project cost as down payment to be borne by the applicant.\nc) Assistance in securing Loan upto 60% of the project Cost. (Additionally, Monthly incentive based on performance upto 30% of payable monthly EMI shall be supported by the Government)\n30% EMI co-payment support provided monthly by Government, subject to performance (minimum 26 trips per month)\nCredit linkage through partner banks\nPre-fitted GPS device with 5-year warranty (cost borne by Government, one-time)\nBranding cost of vehicle borne by Government (first-time only)\nCapacity building and training programs conducted by Meghalaya Transport Corporation (MTC)\nPriority access for local entrepreneurs, SHGs, traditional institutions, and cooperatives to operate on designated routes\nEligibility for a wide range of vehicles (from 13-seater to 32-seater passenger buses, AC/Non-AC options)
45	50	general	Subsidy is disbursed through financing partners.\nLoans are provided by selected partner banks with a repayment period of up to 15 years.\nNo pre-closure penalties for loans.\n80% of the project cost is paid upfront by the Government of Meghalaya.\nThe remaining 20% is provided as a bank loan (5% paid by the entrepreneur and 75% by the government).
46	51	general	5% of project cost to be contributed by the entrepreneur 75% of project cost provided upfront by Government of Meghalaya as margin money support to the bank remaining 20% via bank loan.\nDirect credit linkage with partner banks\nGuidance and handholding in the application process through implementing agencies.\nSupport in project realization for the warehouse venture.\nTraining and capacity building for entrepreneurs to manage post-harvest storage effectively.\nTechnical support for maintenance and operations of warehouses.
47	53	general	Credit linkage through partnered banks\n5% EMI co-payment support for 24 months\nVeterinary and farm management support\nMentorship and business advisory\n50% of project cost supported (5% by applicant, 45% by Government)\nMarket linkage for selling output\nTechnical training and capacity building
48	54	general	50% of project cost supported (5% by applicant, 45% by Government)\n5% EMI co-payment support for 24 months\nCredit linkage through partnered banks\nTechnical training and capacity building\nVeterinary and farm management support\nMarket linkage for selling output\nMentorship and business advisory
49	55	general	50% of project cost supported (5% by applicant, 45% by Government)\n5% EMI co-payment support for 24 months\nCredit linkage through partnered banks\nTechnical training and capacity building\nVeterinary and farm management support\nMarket linkage for selling output\nMentorship and business advisory
50	56	general	50% of project cost supported (5% by applicant, 45% by Government)\n5% EMI co-payment support for 24 months\nCredit linkage through partnered banks\nTechnical training and capacity building\nVeterinary and farm management support\nMarket linkage for selling output\nMentorship and business advisory
51	57	general	50% of project cost supported (5% by applicant, 45% by Government of Meghalaya)\n5% EMI co-payment support for 12 months\nCredit linkage through partnered banks (MRB, MCAB, SBI, SCUB)\nAdditional 3% annual interest subvention on reefer trucks with Aadhaar linkage\nPre-fitted GPS device with 5-year warranty\nBranding cost of vehicle borne by Government\nCapacity building and training programs by Department ,1917iTeams\nMarket linkage through 1917iTeams with live vehicle tracking\nEligibility for various vehicle types, including reefer trucks for perishable goods transportation
52	58	general	50% of total project cost supported as upfront subsidy by Government of Meghalaya (₹50,000 max)\n5% of total project cost to be contributed by entrepreneur as own share\nRemaining 45% of project cost eligible for bank loan\nLoan tenure of 2 years with a 3-month moratorium period before EMI begins\nFinancial support strictly for asset creation (machinery, equipment), operational or working capital expenses not allowed\nOpportunity to access scheme through single online portal under CM-ELEVATE initiative\nCash Credit loan option available for eligible beneficiaries\nSupport to entrepreneurs from unorganized and underserved sectors with emphasis on creating local employment
53	59	general	50% of on-road vehicle cost supported (5% by entrepreneur, 45% by Government of Meghalaya)\n5% EMI co-payment support for 12 months\nCredit linkage through partnered banks\nPre-fitted GPS device with 5-year warranty (cost borne by Government, one-time)\nBranding cost of vehicle borne by Government (first time only)\nMandatory capacity building and training programs under MTOTP by Tourism Department\nSupport from PRIME – Tourism Vehicle Cell for promotion, grievance redressal, and training\nEligibility for multiple vehicle types including 8–17 seater luxury buses, 4x4 vehicles, and MPVs for tourism and adventure tourism
54	52	general	40% upfront subsidy by Government of Meghalaya\nUp to 10% of project cost EMI support\nLoan up to 55% of project cost via MCAB, SBI, etc\n15-year loan term with 18-month moratorium\nMentorship and coaching via PRIME\nSupport for business registration if required
\.


--
-- Data for Name: scheme_documents; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.scheme_documents (id, scheme_id, document_name, is_mandatory) FROM stdin;
42	47	Development of new homestay\nProof of Identity (Passport/Voter ID/Driving License)\nLand Certificate/Rent Agreement\nPhotographs or Site Sketches\nPAN Card (If available)\nUpgradation of existing homestay\nProof of Identity (Passport/Voter ID/Driving License)\nPAN Card (If available)\nLand Certificate/Rent Agreement\nNOC for operations of Homestay (if available)	t
43	48	Individuals\nIncorporation Certificate or Registration Certificate\nProof of Address of Applicant (Voter ID / Passport / Driving License) - President or Secretary\nPAN Card\nLatest Bank Statement (Last 1 Year)\nITR 2024-25 (if available)\nGST Certificate (if available)\nSelf Declaration\nDownload\nRegistered Entities\nIncorporation Certificate or Registration Certificate\nProof of Address of Applicant (Voter ID / Passport / Driving License) - President or Secretary\nPAN Card\n[Organization/Applicant]\nLatest Bank Statement (Last 1 Year)\nITR 2024-25 (if available)\nGST Certificate (if available)\nRation Card of Applicant\nParking Space Picture\nSelf Declaration\nDownload	t
44	49	Individuals\nCommercial Driving License\nProof of Identity of Applicant (Voter ID / Passport / Driving License)\nPAN Card (if available)\nLatest Bank Statement (Last 1 Year)\nRation Card of Applicant\nRegistered Entities\nIncorporation Certificate or Registration Certificate\nCommercial Driving License of Driver\nProof of Identity of President & Secretary (Voter ID / Passport / Driving License)\nPAN Card of President or Secretary (if available)\nLatest Bank Statement (Last 1 Year)\nGST Certificate (if available)\nITR 2023-24 (if available)\nRation Card of Applicant\nUnregistered Entities\nCommercial Driving License\nProof of Identity of President & Secretary (Voter ID / Passport / Driving License)\nPAN Card of President or Secretary (if available)\nLatest Bank Statement (Last 1 Year)\nRation Card of Applicant (if available)\nRecommendation letter from Block Development Officer (BDO)	t
45	50	Producers Group\nFOCUS PG Details – PG Name, Members name, designation\nFamily ID & Citizen ID\nDownload\nBank account details of the PG – Bank name, IFSC, Branch and Bank Account Number\nMemorandum of association\nDownload	t
46	51	Individuals\nProof of Address of Applicant (Voter ID / Passport) (If available)\nRation Card of Applicant\nPAN Card\nLatest Bank Statement (Last 1 Year)\nSelf-attested statement on land availability\nDownload\nSelf Declaration Certificate\nDownload\nRegistered Entities\nSelf-attested declaration certificate for Registered Society\nRation Card of Applicant\nIncorporation Certificate or Registration Certificate\nPAN Card\nGST Certificate (if available)\nProof of Address of Applicant (Voter ID / Passport / Driving License) - President or Secretary\nLatest Bank Statement (Last 1 Year)\nSelf-declaration of President/Secretary of SHG/IVCS/FPO/Others\nDownload\nSelf-attested statement on land availability\nDownload	t
47	53	Individuals\nPAN Card\nLatest Bank Statement (Last 6 months)\nRation Card\nTraining certificate\nProof of Address of Applicant (Voter ID/Passport/Driving License)\nLand ownership or notarized lease certificate (if applicable)\nDownload\nSelf Declaration\nDownload\nRegistered Entities\nLatest Bank Statement (Last 6 months)\nPAN Card\nProof of Address of Applicant (Voter ID / Passport / Driving License)\nGST Certificate (if available)\nIncorporation Certificate or Registration Certificate\nRation Card of Applicant\nTraining certificates for at least 2 members\nLand ownership or notarized lease certificate (if applicable)\nDownload\nSelf Declaration\nDownload\nUnregistered Entities\nPAN Card\nTraining certificates for at least 2 members\nProof of Address of Applicant (Voter ID / Passport / Driving License)\nRation Card of Applicant\nLatest Bank Statement (Last 6 months)\nSelf Declaration\nDownload\nLand ownership or notarized lease certificate (if applicable)\nDownload	t
48	54	Individuals\nLatest Bank Statement (Last 6 months)\nPAN Card\nProof of Address of Applicant (Voter ID/Passport/Driving License)\nRation Card\nTraining certificate\nLand ownership or notarized lease certificate (if applicable)\nDownload\nSelf Declaration\nDownload\nRegistered Entities\nGST Certificate (if available)\nPAN Card\nLatest Bank Statement (Last 6 months)\nProof of Address of Applicant (Voter ID / Passport / Driving License)\nRation Card of Applicant\nTraining certificates for at least 2 members\nIncorporation Certificate or Registration Certificate\nSelf Declaration\nDownload\nLand ownership or notarized lease certificate (if applicable)\nDownload\nUnregistered Entities\nPAN Card\nProof of Address of Applicant (Voter ID / Passport / Driving License)\nLatest Bank Statement (Last 6 months)\nTraining certificates for at least 2 members\nRation Card of Applicant\nSelf Declaration\nDownload\nLand ownership or notarized lease certificate (if applicable)\nDownload	t
49	55	Individuals\nProof of Address of Applicant (Voter ID / Passport / Driving License)\nPAN Card\nLatest Bank Statement (Last 6 months)\nTraining certificate\nRation Card\nSelf Declaration\nDownload\nLand ownership or notarized lease certificate (if applicable)\nDownload\nRegistered Entities\nProof of Address of Applicant (Voter ID / Passport / Driving License)\nIncorporation Certificate or Registration Certificate\nGST Certificate (if available)\nPAN Card\nRation Card of Applicant\nTraining certificates for at least 2 members\nLatest Bank Statement (Last 6 months)\nSelf Declaration\nDownload\nLand ownership or notarized lease certificate (if applicable)\nDownload\nUnregistered Entities\nPAN Card\nProof of Address of Applicant (Voter ID / Passport / Driving License)\nLatest Bank Statement (Last 6 months)\nRation Card of Applicant\nTraining certificates for at least 2 members\nSelf Declaration\nDownload\nLand ownership or notarized lease certificate (if applicable)\nDownload	t
50	56	Individuals\nProof of Address of Applicant (Voter ID/Passport/Driving License)\nPAN Card\nLatest Bank Statement (Last 6 months)\nRation Card\nTraining certificate\nLand ownership or notarized lease certificate (if applicable)\nDownload\nSelf Declaration\nDownload\nRegistered Entities\nGST Certificate (if available)\nIncorporation Certificate or Registration Certificate\nProof of Address of Applicant (Voter ID / Passport / Driving License)\nPAN Card\nTraining certificates for at least 2 members\nLatest Bank Statement (Last 6 months)\nRation Card of Applicant\nSelf Declaration\nDownload\nLand ownership or notarized lease certificate (if applicable)\nDownload\nUnregistered Entities\nProof of Address of Applicant (Voter ID / Passport / Driving License)\nPAN Card\nLatest Bank Statement (Last 6 months)\nRation Card of Applicant\nTraining certificates for at least 2 members\nLand ownership or notarized lease certificate (if applicable)\nDownload\nSelf Declaration\nDownload	t
51	57	Individuals\nLatest Bank Statement (Last 1 Year)\nCommercial Driving License\nProof of Address of Applicant (Voter ID / Passport / Driving License) (If available)\nPAN Card\nSelf Declaration\nDownload\nRation Card of Applicant\nRegistered Entities\nTrade License (if available)\nCommercial Driving License\nPAN Card\nLatest Bank Statement (Last 1 Year)\nGST Certificate (if available)\nIncorporation Certificate or Registration Certificate\nProof of Address of Applicant (Voter ID / Passport) (if available)\nRation Card of Applicant\nSelf Declaration\nDownload\nUnregistered Entities\nLatest Bank Statement (Last 1 Year)\nCommercial Driving License\nProof of Address of Applicant (Voter ID / Passport / Driving License) - President & Secretary\nSelf Declaration\nDownload\nPAN Card of applicant\n(if available)\nRation Card of Applicant\nPAN Card of President or Secretary	t
52	58	Individuals\nLatest Bank Statement (Last 6 months)\nProof of Identity of Applicant (Voter ID / Passport / Driving License)\nSelf Declaration\nDownload\nCertification or testimonial from Village Headman or experience proof for existing operators (registration, photos, testimonials, etc.)\nPAN Card\nRation Card of Applicant\nQuotation for equipment to be purchased (must include vendor GST number)\nUnregistered Entities\nProof of Identity of Applicant (Voter ID / Passport / Driving License) - President & Secretary\nLatest Bank Statement (Last 6 months)\nSelf Declaration\nDownload\nCertification or testimonial from Village Headman or experience proof for existing operators (registration, photos, testimonials, etc.)\nPAN Card\nRation Card of Applicant\nQuotation for equipment to be purchased (must include vendor GST number)	t
53	59	Individuals\nCommercial Driving License\nProof of Address of Applicant (Voter ID / Passport / Driving License) (if available)\nRation Card of Applicant\nPAN Card\nLatest Bank Statement (Last 1 Year)\nSelf Declaration\nDownload\nRegistered Entities\nCommercial Driving License\nLatest Bank Statement (Last 1 Year)\nGST Certificate (if available)\nTrade License (if available)\nIncorporation Certificate or Registration Certificate\nPAN Card\nGST Return (if available)\nLatest ITR (if available)\nProof of Address of Applicant (Voter ID / Passport / Driving License) - President or Secretary\nRation Card of Applicant\nSelf Declaration\nDownload\nUnregistered Entities\nCommercial Driving License\nPAN Card of Applicant (if available)\nPAN Card of President or Secretary\nLatest Bank Statement (Last 1 Year)\nProof of Address of Applicant (Voter ID / Passport / Driving License) - President or Secretary\nSelf Declaration\nDownload\nRation Card of Applicant	t
54	52	Individuals\nProof of Address of Applicant (Voter ID/Passport/Driving License)\nRation Card (If available)\nSelf Declaration\nDownload\nDetailed Project Report (DPR)\nDownload\nLand ownership or notarized lease certificate (if applicable)\nDownload\nRegistered Entities\nRation Card (If available)\nProof of Address of the President/Secretary(Voter ID / Passport / Driving License)\nSelf Declaration\nDownload\nIncorporation Certificate or Registration Certificate\nLand ownership or notarized lease certificate (if applicable)\nDownload\nDetailed Project Report (DPR)\nDownload	t
\.


--
-- Data for Name: scheme_eligibility; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.scheme_eligibility (id, scheme_id, rule_type, rule_value) FROM stdin;
46	48	general	Individuals\nIndividuals who are permanent residents of Meghalaya are eligible for the scheme.\nEligibility criteria for Individual entrepreneurs:\nMust be above 18 years of age and below 58 years of age.\nMust have experience as a driving license.\nMust be a resident of Greater Shillong Planning Area (GSPA) and provide valid Government issued ID proof with an address like Aadhar Card, Voter ID, Passport, Driving license.\nEntrepreneurs shall not be credit defaulters from any bank.\nApplications shall not be ordinarily considered for the following:\nIndividuals currently employed either on a full time or contractual basis under the State or Central Government, as well as those retired and receiving a Government pension, along with their immediate family members (spouse, parents, and unmarried sons or daughters up to 30 years of age), provided that such sons or daughters are neither dependent nor employed (full time or contractual) under the State or Central Government.\nAny individual whose job is concerned with politics such MLAs, MDCs, MPs etc. or seeking to hold a similar position in Government.\nRegistered class-1 contractors.\nConsultants who are currently engaged with State or Central Government.\nRegistered Entities\nMust provide an Incorporation Certificate or a Registration Certificate, whichever is applicable\nAll recognized and registered taxicab operators/ organizations, Self Help Groups, Co-operatives etc. based in Greater Shillong Planning Area can apply\nMust have registered office/ certificate of incorporation/ License to operate city taxi in Grater Shillong Planning Area can apply\nShall not be credit defaulters from any bank\nApplications shall not be ordinarily considered for the following:\nState and Central Government employees.\nEmployees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\nAny individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\nRegistered class-1 contractors\nPressure groups and organizations that are primarily political in nature shall not be ordinarily considered\nConsultants who are currently engaged with state or central government
45	47	general	Development of new homestay\nApplicants are required to complete the application process and submit all the required documents online on the Meghalaya One portal.\nAs proof of eligibility, the applicants are required to provide the following documents:\ni. A valid photo identity with an address which includes Aadhar Card, Voter ID, Passport, Driving License or Pan Card, if available.\nii. Highest Education certificate\niii. Certificate of Disability, in case the applicant is applying under PwD category\niv. No objection certificate for the development of homestay from the local authorities\nv. Proof of landownership or registered lease for a minimum period of 7 years.\nvi. Any other documents as required by the Department and the partner bank\nThe applicant at the time of application will be required to choose one homestay design out of the 33 standard designs (attached as Annexure 5) prepared by the Department of Tourism.\nUpgradation of existing homestay\nApplicants are required to complete the application process and submit all the required documents online on the Meghalaya One portal.\nAs proof of eligibility, the applicants are required to provide the following documents:\ni. A valid photo identity with an address, which includes Aadhar Card, Voter ID, Passport, Driving License, or PAN Card, if available.\nii. Proof of operations of the homestay (6 months guest register, recorded a minimum of 50 bed nights, and must be registered and actively using the Meghalaya M-TIME portal).\niii. NOC from local authorities for operations of the homestay.\nThe applicant shall provide a list of upgradation work that he or she is willing to undertake, along with cost estimates and quotations from vendors.
47	49	general	Individuals\nIndividuals who are permanent residents of Meghalaya are eligible for the scheme.\nMust be above 18 years of age and below 58 years of age\nMust have experience as a commercial driver\nMust provide valid government issued ID proof with an address which includes Voter ID, Passport, Driving License\nEntrepreneurs shall not be credit defaulters from any bank\nPriority will be given to Individual Entrepreneurs belonging to the respective Block for routes originating from that particular Block, followed by the entrepreneur belonging to the corresponding District.\nOnly one member from a family is eligible for the scheme.\nIndividuals currently employed either on a full-time or contractual basis under the State or Central Government, as well as those retired and receiving a Government pension, along with their immediate family members (spouse, parents, and unmarried sons or daughters up to 30 years of age), provided that such sons or daughters are neither dependent nor employed (full-time or contractual) under the State or Central Government.\ni. Employees of public sector undertakings, subsidiaries of public sector undertakings, and divisions of public sector undertakings etc.\nii. Any individual whose job is concerned with politics such as MLAs, MLCs, MPs etc., or those seeking to hold a similar position in Government.\niii. Registered class-1 contractors.\niv. Consultants who are currently engaged with State or Central Government.\nRegistered Entities\nAll recognized and registered bus operators and maxi cab operators etc. based in Meghalaya can apply.\nShall have experience in operating public transport vehicles (Buses, Maxi Cabs, Taxis etc.)\nShall not be a defaulter at any financial institution.\nPriority will be given to registered entities belonging to the respective Block for routes originating from that particular Block, followed by the registered entities belonging to the corresponding District.\nMust provide an Incorporation Certificate or a Registration Certificate, whichever is applicable.\nShall not be credit defaulters from any bank.\nPressure groups and organizations that are primarily political in nature shall not be ordinarily considered.\nUnregistered Entities\nAny unregistered entity such as Village Organizations, Self-Help Groups (SHGs), Traditional communities etc. based in Meghalaya can apply.\nEligibility conditions:\ni. A letter of recommendation from the Block Development Officer (BDO).\nii. Shall not be a credit defaulter at any financial institution.\niii. Priority will be given to unregistered entities belonging to the respective Block for routes originating from that particular Block, followed by the unregistered entities belonging to the corresponding District.\niv. Pressure groups and organizations that are primarily political in nature shall not be ordinarily considered.
48	50	general	Producers Group\nGroup of 10-20 member producers from the same village who are engaged in the same or similar types of agricultural/allied activities that have a high potential for income generation, to form a Producer Group (PG). PG members should be holder of Family/Citizen ID of Meghalaya. All members of the PGs should be from different households with different Family ID of Meghalaya
49	51	general	Individuals\nAge between 18 and 58 years\nIndividuals who are permanent residents of Meghalaya are eligible for the scheme\nMust have ownership of the land on which the warehouse is proposed or a leased land for at least the next 10 years\nMust provide valid government ID proof with address (Voter ID, Passport, Driving License)\nShall not be a credit defaulter from any bank\nApplications shall not be ordinarily considered for the following:\nA) Pressure groups and organizations that are primarily political in nature shall not be ordinarily considered\nB) Only one member from a family is eligible for the scheme\nC) Following individuals (currently employed as full-fledged or contractual, or retired and drawing pension) and their immediate family members which includes spouse, parents, and children up to the age of 30:\ni. State and Central Government employees\nii. Employees of public sector undertakings, subsidiaries of public sector undertakings, and divisions of public sector undertakings etc.\niii. Any individual whose job is concerned with politics such as MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\niv. Registered class-1 contractors\nv. Consultants who are currently engaged with state or central government\nRegistered Entities\nMust provide an Incorporation Certificate or a Registration Certificate, whichever is applicable\nMust be based in the village for which the program is being availed\nMust have an active bank account and submit the bank statement of the last 6 months\nMust have been in operation for at least two years\nMust provide valid government ID proof with address of the President/Secretary (Voter ID, Passport, Driving License)\nShould possess land, either self-owned or on lease, duly verified by the competent authority\nShall not be credit defaulters from any bank\nApplications shall not be ordinarily considered for the following\ni) State and Central Government employees\nii) Employees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\niii) Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\niv) Registered class-1 contractors\nv) Pressure groups and organizations that are primarily political in nature shall not be ordinarily considered\nv) Consultants who are currently engaged with state or central government
50	53	general	Individuals\nMust provide valid government ID proof with an address such as Voter ID, Passport, Driving License\nAge between 18 and 58 years\nShould possess land, either self-owned or on lease, verified by the competent authority\nShould possess a training certificate on the sector applied for from a recognized Institution, preferably from a Government Institute\nPreference for availing loans will be given to entrepreneurs and entities with prior experience of undertaking Dairy\nThe entrepreneur must have access to adequate and quality feed for the cattle\nThe entrepreneur must have a vaccination Scheme in place for the cattle\nThe entrepreneur must have a plan for marketing dairy products\nThe entrepreneurs village must be in an area where dairy farming is feasible\nThe distance between the entrepreneurs village and the nearest market must be reasonable\nThe entrepreneur should not be a credit defaulter from any bank\nApplications shall not be ordinarily considered for the following\nA)\nFollowing individuals (currently employed as full-fledged or contractual, or retired and drawing pension) and their Immediate family members which includes spouse, parents, and children up to the age of 30\ni. State and Central Government employees\nii.\nEmployees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\niii. Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\niv.\nRegistered class-1 contractors\nv.\nConsultants who are currently engaged with state or central government\nB)\nOnly one member from a family is eligible for the scheme.\nC)\nPressure groups and organizations that are primarily political in nature\nRegistered Entities\nAny group/entity registered in Meghalaya such as Cooperatives, Farmer Producer Companies (FPC), Farmer Producer Organization (FPO) and so on\nMust provide an Incorporation Certificate or a registration certificate whichever is applicable\nAt least two members should possess a training certificate on the sector applied for from a recognized institution, preferably from a government institute\nShould possess land, either self-owned or on lease, verified by the competent authority\nShould possess a training certificate on the sector applied for from a recognized Institution, preferably from a Government Institute\nPreference for availing loans will be given to entrepreneurs and entities with prior experience of undertaking Dairy\nThe entrepreneur must have access to adequate and quality feed for cattle\nThe entrepreneur must have a vaccination Scheme in place for the cattle\nThe entrepreneur must have a plan for marketing the dairy products\nThe entrepreneurs village must be in an area where dairy farming is feasible\nThe distance between the entrepreneurs village and the nearest market must be reasonable\nThe entrepreneur should not be a credit defaulter from any bank\nApplications shall not be ordinarily considered for the following\nA) Only one member from a family is eligible for the scheme.\nB) Pressure groups and organizations that are primarily political in nature\nC) Following individuals (currently employed as full-fledged or contractual, or retired and drawing pension) and their Immediate family members which includes spouse, parents, and children up to the age of 30\ni. State and Central Government employees\nii. Employees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\niii. Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\niv. Registered class-1 contractors\nv. Consultants who are currently engaged with state or central government\nUnregistered Entities\nTraditional institutions, shelf help groups, producer groups and so on\nEligibility certification from competent government authority like BDO/SDO/Department in case of Producer group from DPMs\nThe non-registered entity must have a constitution/bylaws/framework that outline the groups structure, objectives, and procedures\nShould possess land, either self-owned or on lease, verified by the competent authority\nShould possess a training certificate on the sector applied for from a recognized Institution, preferably from a Government Institute\nPreference for availing loans will be given to entrepreneurs and entities with prior experience of undertaking Dairy\nThe entrepreneur must have access to adequate and quality feed for cattle\nThe entrepreneur must have a vaccination Scheme in place for the cattle\nThe entrepreneur must have a plan for marketing the dairy products.\nThe entrepreneurs village must be in an area where dairy farming is feasible\nThe distance between the entrepreneurs village and the nearest market must be reasonable\nThe entrepreneur should not be a credit defaulter from any bank\nApplications shall not be ordinarily considered for the following\nA) Only one member from a family is eligible for the scheme.\nB) Pressure groups and organizations that are primarily political in nature\nC) Following individuals (currently employed as full-fledged or contractual, or retired and drawing pension) and their Immediate family members which includes spouse, parents, and children up to the age of 30\ni. State and Central Government employees\nii. Employees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\niii. Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\niv. Registered class-1 contractors\nv. Consultants who are currently engaged with state or central government
51	54	general	Individuals\nMust provide valid government ID proof with an address such as Voter ID, Passport, Driving License\nAge between 18 and 58 years\nShould possess land, either self-owned or on lease, verified by the competent authority\nShould possess a training certificate on the sector applied for from a recognized Institution, preferably from a Government Institute\nPreference for availing loans will be given to entrepreneurs and entities with prior experience of undertaking Goatery\nThe entrepreneur must have access to adequate and quality feed for the goats\nThe entrepreneur must have a vaccination Scheme in place for the goats\nThe entrepreneur must have a plan for marketing the goats and their products\nThe entrepreneurs village must be in an area where goat rearing is feasible\nThe distance between the entrepreneur’s village and the nearest market must be reasonable\nThe entrepreneur should not be a credit defaulter from any bank\nApplications shall not be ordinarily considered for the following\nA) Following individuals (currently employed as full-fledged or contractual, or retired and drawing pension) and their Immediate family members which includes spouse, parents, and children up to the age of 30\ni. State and Central Government employees\nii. Employees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\niii. Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\niv. Registered class-1 contractors\nv. Consultants who are currently engaged with state or central government\nB) Only one member from a family is eligible for the scheme.\nC) Pressure groups and organizations that are primarily political in nature\nRegistered Entities\nAny group/entity registered in Meghalaya such as Cooperatives, Farmer Producer Companies (FPC), Farmer Producer Organization (FPO) and so on\nMust provide an Incorporation Certificate or a registration certificate whichever is applicable\nAt least two members should possess a training certificate on the sector applied for from a recognized institution, preferably from a government institute\nShould possess land, either self-owned or on lease, verified by the competent authority\nShould possess a training certificate on the sector applied for from a recognized Institution, preferably from a Government Institute\nPreference for availing loans will be given to entrepreneurs and entities with prior experience of undertaking Goatery\nThe entrepreneur must have access to adequate and quality feed for the goats\nThe entrepreneur must have a vaccination Scheme in place for the goats\nThe entrepreneur must have a plan for marketing the goats & their products\nThe entrepreneurs village must be in an area where goat rearing is feasible\nThe distance between the entrepreneur’s village and the nearest market must be reasonable\nThe entrepreneur should not be a credit defaulter from any bank\nApplications shall not be ordinarily considered for the following\nA) Only one member from a family is eligible for the scheme.\nB) Pressure groups and organizations that are primarily political in nature\nC) Following individuals (currently employed as full-fledged or contractual, or retired and drawing pension) and their Immediate family members which includes spouse, parents, and children up to the age of 30\ni. State and Central Government employees\nii. Employees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\niii. Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\niv. Registered class-1 contractors\nv. Consultants who are currently engaged with state or central government\nUnregistered Entities\nTraditional institutions, self help groups, producer groups and so on\nEligibility certification from competent government authority like BDO/SDO/Department in case of Producer group from DPMs\nThe non-registered entity must have a constitution/bylaws/framework that outline the groups structure, objectives, and procedures\nShould possess land, either self-owned or on lease, verified by the competent authority\nShould possess a training certificate on the sector applied for from a recognized Institution, preferably from a Government Institute\nPreference for availing loans will be given to entrepreneurs and entities with prior experience of undertaking Goatery\nThe entrepreneur must have access to adequate and quality feed for the goats\nThe entrepreneur must have a vaccination Scheme in place for the goats\nThe entrepreneur must have a plan for marketing the goats & their  products.\nThe entrepreneurs village must be in an area where goat rearing is feasible\nThe distance between the entrepreneurs village and the nearest market must be reasonable\nThe entrepreneur should not be a credit defaulter from any bank\nApplications shall not be ordinarily considered for the following\nA) Only one member from a family is eligible for the scheme.\nB) Pressure groups and organizations that are primarily political in nature\nC) Following individuals (currently employed as full-fledged or contractual, or retired and drawing pension) and their Immediate family members which includes spouse, parents, and children up to the age of 30\ni. State and Central Government employees\nii. Employees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\niii. Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\niv. Registered class-1 contractors\nv. Consultants who are currently engaged with state or central government
57	52	general	Individuals\nAge between 18 and 58 years\nAll partners involved in the proposal must be residents of the state of Meghalaya. Valid identification documents demonstrating residency will be required as part of the application\nApplicants must provide proof of relevant experience in the field related to the proposed project. Fresh applicants without demonstrated experience will not be considered\nThe proposal must include proof of land ownership or a valid lease agreement for the proposed establishment\nApplicants must demonstrate their commitment to the project by providing proof of the required contributing share. This can include financial contributions, resources, or any other form of investment outlined\nThe proposed establishment must commit to employing locals in accordance with the funds they have received and the kind of unit they are running\nApplications shall not be ordinarily considered for the following\nA) Following individuals (currently employed as full-fledged or contractual, or retired and drawing pension) and their Immediate family members which includes spouse, parents, and children up to the age of 30\ni. State and Central Government employees\nii. Employees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\niii. Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\niv. Registered class-1 contractors\nv. Consultants who are currently engaged with state or central government\nB) Only one member from a family is eligible for the scheme.\nC) Pressure groups and organizations that are primarily political in nature\nRegistered Entities\nAge between 18 and 58 years\nAll partners involved in the proposal must be residents of the state of Meghalaya. Valid identification documents demonstrating residency will be required as part of the application\nApplicants must provide proof of relevant experience in the field related to the proposed project. Fresh applicants without demonstrated experience will not be considered\nThe proposal must include proof of land ownership or a valid lease agreement for the proposed establishment\nApplicants must demonstrate their commitment to the project by providing proof of the required contributing share. This can include financial contributions, resources, or any other form of investment outlined\nThe proposed establishment must commit to employing locals in accordance with the funds they have received and the kind of unit they are running\nApplications shall not be ordinarily considered for the following\nA) Following individuals (currently employed as full-fledged or contractual, or retired and drawing pension) and their Immediate family members which includes spouse, parents, and children up to the age of 30\ni. State and Central Government employees Employees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\nii. Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\niii. Registered class-1 contractors\niv. Consultants who are currently engaged with state or central government\nB) Only one member from a family is eligible for the scheme.\nC) Pressure groups and organizations that are primarily political in nature
52	55	general	Individuals\nMust provide valid government ID proof with an address such as Voter ID, Passport, Driving License\nAge between 18 and 58 years\nShould possess land, either self-owned or on lease, verified by the competent authority\nShould possess a training certificate on the sector applied for from a recognized Institution, preferably from a Government Institute\nPreference for availing loans will be given to entrepreneurs and entities with prior experience of undertaking piggery.\nThe entrepreneur must have access to adequate and quality feed for the pigs.\nThe entrepreneur must have a vaccination Scheme in place for the pigs.\nThe entrepreneur must have a plan for marketing the pigs and their products.\nThe entrepreneur’s village must be in an area where pig rearing is feasible.\nThe distance between the entrepreneur’s village and the nearest market must be reasonable.\nThe entrepreneur should not be a credit defaulter from any bank.Must possess self-owned or notarized lease land (≥15 years)\nApplications shall not be ordinarily considered for the following\nA) Following individuals (currently employed as full-fledged or contractual, or retired and drawing pension) and their Immediate family members which includes spouse, parents, and children up to the age of 30\ni. State and Central Government employees\nii. Employees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\niii. Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\niv. Registered class-1 contractors\nv. Consultants who are currently engaged with state or central government\nB) Only one member from a family is eligible for the scheme.\nC) Pressure groups and organizations that are primarily political in nature\nRegistered Entities\nRegistered Entities from Meghalaya such as any group/entity registered in Meghalaya such as Cooperatives, Farmer Producer Companies (FPC), Farmer Producer Organization (FPO) and so on.\nMust provide an Incorporation Certificate or a registration certificate whichever is applicable.\nShould possess land, either self-owned or on lease, verified by the competent authority\nShould possess a training certificate on the sector applied for from a recognized Institution, preferably from a Government Institute\nPreference for availing loans will be given to entrepreneurs and entities with prior experience of undertaking piggery.\nThe entrepreneur must have access to adequate and quality feed for the pigs.\nThe entrepreneur must have a vaccination Scheme in place for the pigs.\nThe entrepreneur must have a plan for marketing the pigs and their products.\nThe entrepreneur’s village must be in an area where pig rearing is feasible.\nThe distance between the entrepreneur’s village and the nearest market must be reasonable.\nThe entrepreneur should not be a credit defaulter from any bank. Must possess self-owned or notarized lease land (≥15 years)\nApplications shall not be ordinarily considered for the following\nA) Only one member from a family is eligible for the scheme.\nB) Pressure groups and organizations that are primarily political in nature\nC) Following individuals (currently employed as full-fledged or contractual, or retired and drawing pension) and their Immediate family members which includes spouse, parents, and children up to the age of 30\ni. State and Central Government employees\nii. Employees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\niii. Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\niv. Registered class-1 contractors\nv. Consultants who are currently engaged with state or central government\nUnregistered Entities\nUnregistered Entities from Meghalaya such as Traditional institutions, self-help groups, producer groups and so on.\nThe non-registered entity must have a constitution/bylaws/framework that outlines the groups structure, objectives, and procedures.\nShould possess land, either self-owned or on lease, verified by the competent authority\nShould possess a training certificate on the sector applied for from a recognized Institution, preferably from a Government Institute\nPreference for availing loans will be given to entrepreneurs and entities with prior experience of undertaking piggery.\nThe entrepreneur must have access to adequate and quality feed for the pigs.\nThe entrepreneur must have a vaccination Scheme in place for the pigs.\nThe entrepreneur must have a plan for marketing the pigs and their products.\nThe entrepreneurs village must be in an area where pig rearing is feasible.\nThe distance between the entrepreneurs village and the nearest market must be reasonable.\nThe entrepreneur should not be a credit defaulter from any bank.Must possess self-owned or notarized lease land (≥15 years)\nApplications shall not be ordinarily considered for the following\nA) Only one member from a family is eligible for the scheme.\nB) Pressure groups and organizations that are primarily political in nature\nC) Following individuals (currently employed as full-fledged or contractual, or retired and drawing pension) and their Immediate family members which includes spouse, parents, and children up to the age of 30\ni. State and Central Government employees\nii. Employees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\niii. Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\niv. Registered class-1 contractors\nv. Consultants who are currently engaged with state or central government
53	56	general	Individuals\nMust provide valid government ID proof with an address such as Voter ID, Passport, Driving License\nAge between 18 and 58 years\nShould possess land, either self-owned or on lease, verified by the competent authority\nShould possess a training certificate on the sector applied for from a recognized Institution, preferably from a Government Institute\nPreference for availing loans will be given to entrepreneurs and entities with prior experience of undertaking Poultry\nThe entrepreneur must have access to adequate and quality feed for the birds\nThe entrepreneur must have a vaccination Scheme in place for the birds\nThe entrepreneur must have a plan for marketing the poultry products.\nThe entrepreneurs village must be in an area where poultry farming is feasible\nThe distance between the entrepreneur’s village and the nearest market must be reasonable\nThe entrepreneur should not be a credit defaulter from any bank\nApplications shall not be ordinarily considered for the following\nA)\nFollowing individuals (currently employed as full-fledged or contractual, or retired and drawing pension) and their Immediate family members which includes spouse, parents, and children up to the age of 30\ni. State and Central Government employees\nii. Employees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\niii. Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\niv. Registered class-1 contractors\nv. Consultants who are currently engaged with state or central government\nB) Only one member from a family is eligible for the scheme.\nC) Pressure groups and organizations that are primarily political in nature\nRegistered Entities\nAny group/entity registered in Meghalaya such as Cooperatives, Farmer Producer Companies (FPC), Farmer Producer Organization (FPO) and so on\nMust provide an Incorporation Certificate or a registration certificate whichever is applicable\nAt least two members should possess a training certificate on the sector applied for from a recognized institution, preferably from a government institute\nShould possess land, either self-owned or on lease, verified by the competent authority\nShould possess a training certificate on the sector applied for from a recognized Institution, preferably from a Government Institute\nPreference for availing loans will be given to entrepreneurs and entities with prior experience of undertaking Poultry\nThe entrepreneur must have access to adequate and quality feed for the birds.\nThe entrepreneur must have a vaccination Scheme in place for the birds\nThe entrepreneur must have a plan for marketing the poultry products.\nThe entrepreneurs village must be in an area where poultry farming is feasible\nThe distance between the entrepreneur’s village and the nearest market must be reasonable\nThe entrepreneur should not be a credit defaulter from any bank\nApplications shall not be ordinarily considered for the following\nA) Only one member from a family is eligible for the scheme.\nB) Pressure groups and organizations that are primarily political in nature\nC) Following individuals (currently employed as full-fledged or contractual, or retired and drawing pension) and their Immediate family members which includes spouse, parents, and children up to the age of 30\ni. State and Central Government employees\nii. Employees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\niii. Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\niv. Registered class-1 contractors\nv. Consultants who are currently engaged with state or central government\nUnregistered Entities\nTraditional institutions, shelf help groups, producer groups and so on\nEligibility certification from competent government authority like BDO/SDO/Department in case of Producer group from DPMs\nThe non-registered entity must have a constitution/bylaws/framework that outline the groups structure, objectives, and procedures\nShould possess land, either self-owned or on lease, verified by the competent authority\nShould possess a training certificate on the sector applied for from a recognized Institution, preferably from a Government Institute\nPreference for availing loans will be given to entrepreneurs and entities with prior experience of undertaking Poultry\nThe entrepreneur must have access to adequate and quality feed for the birds\nThe entrepreneur must have a vaccination Scheme in place for the birds\nThe entrepreneur must have a plan for marketing the poultry products.\nThe entrepreneurs village must be in an area where poultry farming is feasible\nThe distance between the entrepreneur’s village and the nearest market must be reasonable\nThe entrepreneur should not be a credit defaulter from any bank\nApplications shall not be ordinarily considered for the following\nA) Only one member from a family is eligible for the scheme.\nB) Pressure groups and organizations that are primarily political in nature\nC) Following individuals (currently employed as full-fledged or contractual, or retired and drawing pension) and their Immediate family members which includes spouse, parents, and children up to the age of 30\ni. State and Central Government employees\nii. Employees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\niii. Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\niv. Registered class-1 contractors\nv. Consultants who are currently engaged with state or central government
54	57	general	Individuals\nAge between 18 and 58 years\nMust have a valid commercial driving license\nIndividuals who are permanent residents of Meghalaya are eligible for the scheme.\nMust be involved with the agriculture sector for a minimum of two years. A letter of certification needs to be provided from the Block Development Officer (BDO) to support the claim\nThe entrepreneur should not be a credit defaulter from any bank\nApplications shall not be ordinarily considered for the following\nA) Following individuals (currently employed as full-fledged or contractual, or retired and drawing pension) and their Immediate family members which includes spouse, parents, and children up to the age of 30\ni. State and Central Government employees\nii. Employees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\niii. Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\niv\n.\nRegistered class-1 contractors\nv. Consultants who are currently engaged with state or central government\nB) Only one member from a family is eligible for the scheme.\nRegistered Entities\nAny registered group of farmers involved with agricultural products and legally registered with the government of Meghalaya such as Cooperatives, Farmer Producer Companies (FPC), Farmer Producer Organisation (FPO) etc. are eligible to apply for the scheme\nMust be involved with the agriculture sector for a minimum of two years. A letter of certification needs to be provided from the Block Development Officer (BDO) to support the claim\nShould not be a beneficiary under the first phase of the Prime Agriculture Response Vehicle Scheme\nMust provide an Incorporation Certificate or a registration certificate whichever is applicable\nAt least two members should possess a training certificate on the sector applied for from a recognized institution, preferably from a government institute\nThe entrepreneur should not be a credit defaulter from any bank\nApplications shall not be ordinarily considered for the following\nA) State and Central Government employees\nB) Employees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\nC) Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\nD) Registered class-1 contractors\nE) Pressure groups and organizations that are primarily political in nature\nF) Consultants who are currently engaged with state or central government\nUnregistered Entities\nAny unregistered entity such as village organizations, self-help groups, producer groups and any other traditional institutions based in Meghalaya can apply\nMust be involved with the agriculture sector for a minimum of two years. A letter of certification needs to be provided from the Block Development Officer (BDO) to support the claim\nShould not be a defaulter at any financial institution\nShould not be a beneficiary under the first phase of the Prime Agriculture Response Vehicle Scheme\nApplications shall not be ordinarily considered for the following\nA) State and Central Government employees\nB) Employees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\nC) Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\nD) Registered class-1 contractors\nE) Pressure groups and organizations that are primarily political in nature\nF) Consultants who are currently engaged with state or central government
55	58	general	Individuals\nAge between 18 and 58 years\nApplicants must provide proof of relevant experience in the field related to the proposed project. Fresh applicants without demonstrated experience will not be considered. Experience can be substantiated through past projects, portfolios, certifications, or testimonials (from village headman)\nIndividuals who are permanent residents of Meghalaya are eligible for the scheme.\nThe entrepreneur should not be a credit defaulter from any bank\nApplications shall not be ordinarily considered for the following\nA)\nFollowing individuals (currently employed as full-fledged or contractual, or retired and drawing pension) and their Immediate family members which includes spouse, parents, and children up to the age of 30\ni) State and Central Government employees\nii) Employees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\niii) Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\niv) Registered class-1 contractors\nv) Consultants who are currently engaged with state or central government\nvi) Pressure groups and organizations that are primarily political in nature shall not be ordinarily considered\nB)\nOnly one member from a family is eligible for the scheme.\nUnregistered Entities\nAny unregistered entity such as village organizations, self-help groups, traditional communities etc. based in Meghalaya can apply\nApplicants must provide proof of relevant experience in the field related to the proposed project. Fresh applicants without demonstrated experience will not be considered. Experience can be substantiated through past projects, portfolios, certifications, or testimonials (from village headman)\nShall not be a credit defaulter at any financial institution\nApplications shall not be ordinarily considered for the following\ni) State and Central Government employees\nii) Employees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\niii) Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\niv) Registered class-1 contractors\nv) Pressure groups and organizations that are primarily political in nature\nvi) Consultants who are currently engaged with state or central government
56	59	general	Individuals\nAge between 18 and 58 years\nMust have a valid commercial driving license\nIndividuals who are permanent residents of Meghalaya are eligible for the scheme.\nMust be involved with the tourism sector. Entrepreneurs applying for 4X4 vehicles must be associated with adventure tourism sector\nThe entrepreneur should not be a credit defaulter from any bank\nApplications shall not be ordinarily considered for the following\nA) Following individuals (currently employed as full-fledged or contractual, or retired and drawing pension) and their Immediate family members which includes spouse, parents, and children up to the age of 30\ni. State and Central Government employees\nii. Employees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\niii. Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\niv. Registered class-1 contractors\nv. Consultants who are currently engaged with state or central government\nvi. Pressure groups and organizations that are primarily political in nature shall not be ordinarily considered\nB) Only one member from a family is eligible for the scheme.\nRegistered Entities\nAll recognized and registered tour operators, tourism societies etc. based on Meghalaya can apply\nShall have experience in the tourism sector\nApplying for 4X4 vehicles must be associated with adventure tourism sector\nShall not be a defaulter at any financial institution\nShall not be beneficiary under the first phase of the Prime Tourism Vehicle Scheme.\nMust provide an Incorporation Certificate or a registration certificate whichever is applicable\nShall not be credit defaulters from any bank\nApplications shall not be ordinarily considered for the following\ni) State and Central Government employees\nii) Employees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\niii) Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\niv) Registered class-1 contractors\nv) Pressure groups and organizations that are primarily political in nature shall not be ordinarily considered\nvi) Consultants who are currently engaged with state or central government\nUnregistered Entities\nAny unregistered entity such as village organizations, self-help groups, traditional communities etc. based in Meghalaya can apply\nMust be involved with the tourism sector. A certification from the Block Development Officer (BDO) is needed to support the claim\nShall not be a credit defaulter at any financial institution\nShall not be a beneficiary under the first phase of the Prime Tourism Vehicle Scheme\nApplications shall not be ordinarily considered for the following\ni) State and Central Government employees\nii) Employees of public sector undertakings, subsidiaries of public sector undertakings and divisions of public sector undertakings etc.\niii) Any individual whose job is concerned with politics such MLAs, MLCs, MPs etc. or seeking to hold a similar position in government\niv) Registered class-1 contractors\nv) Pressure groups and organizations that are primarily political in nature\nvi) Consultants who are currently engaged with state or central government
\.


--
-- Data for Name: scheme_faqs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.scheme_faqs (id, scheme_id, question, answer) FROM stdin;
\.


--
-- Data for Name: schemes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.schemes (id, name, description, apply_how, deadline, rejection_reasons, source_url, last_updated, application_status) FROM stdin;
47	CHIEF MINISTER'S MEGHALAYA HOMESTAY MISSION SCHEME	The Chief Minister's Meghalaya Homestay Mission Scheme, launched by the Department of Tourism, Government of Meghalaya, is aimed at strengthening tourism infrastructure and promoting \ncommunity-led hospitality. The scheme focuses on developing new homestays and \nupgrading existing ones to enhance Meghalaya’s position as a leading eco-tourism destination while creating sustainable livelihood opportunities.	Online Submission:\nApplications must be submitted online through the Meghalaya One portal, under the Family ID framework, along with all required documents.\nScreening:\nApplications will be verified and shortlisted based on eligibility and documentation by the District Tourism Officer (DTO) and partner bank, followed by scrutiny by the State Level Screening Committee (SLSC), comprising representatives from the Department of Tourism, DTOs, and partner banks.\nSite Visit & Evaluation:\nFor new homestays, feasibility of location and conformity with scheme norms will be assessed through joint site inspections by the DTO and bank representatives. For upgradation cases, physical inspections and validation through the M-TIME portal will be conducted.\nFinal Approval:\nThe Sanctioning Committee headed by the Commissioner & Secretary, Department of Tourism, grants final approvals based on SLSC recommendations. Approval/sanction letters are then issued to selected applicant	\N	\N	https://meghalayaone.gov.in/meghalaya-one/view-detail?U2FsdGVkX18OIz3gziUlXhxeuULhtBeyxTdiXIxveInTWzAGwMQ%2Fq8A7CGqqQHI2jD900FLNHtxpbYX446%2FPKy0993IUWbHHIWltB%2FCigfCCQqm8skleOCe5BPedpLFhYxLhJHR2VYfhnxwPiXbKbchT99WC02tQy1c780MDzroX81B1bSvA6vImMksQuyeF6QIet7IoMS17QHIjncwhCxmqtQTaPCzxeP7UqIAT%20X4050sWeQ0zu%2FWImmxHRe7b=	2026-07-01 14:50:13.264433	Status not available on official portal
57	PRIME AGRICULTURE RESPONSE VEHICLE SCHEME	PRIME Agriculture Response Vehicle Scheme is a component under the Chief Minister’s ELEVATE program launched by the Government of Meghalaya. It aims to employ, engage, and empower the youth and rural communities by promoting entrepreneurship in agriculture logistics, addressing critical gaps in farm-to-market connectivity. The scheme provides easy access to credit through onboarding of multiple partner banks, coupled with substantial government support in the form of upfront capital subsidy and EMI co-payment. By enabling entrepreneurs to procure small commercial vehicles, pickups, trucks, and refrigerated carriers, it seeks to improve transportation efficiency, reduce post-harvest losses, and enhance market access for farmers, especially in remote areas. Implemented by the Department of Agriculture & Farmers’ Welfare, the scheme integrates with 1917iTeams for generating transport demand, GPS-enabled tracking, and providing training and capacity building—ensuring beneficiaries can operate profitably while strengthening the agricultural value chain in Meghalaya.	Interview & Inspection:\nVirtual pitch, physical interview and site inspection by Department and bank teams shall be done as and when required.\nFinal Approval:\nState Sanction Committee issues approval letters.\nOnline Submission:\nApply via Meghalaya One  Portal with all supporting documents and DPR (if requested).\nScreening:\nDistrict and State committees shall verify and shortlist applications. The committees can also conduct physical background verification for shortlisted candidates if required	\N	\N	https://meghalayaone.gov.in/meghalaya-one/view-detail?U2FsdGVkX1%202c3iPwV2bvSfoFyQEKy5fSwc9TVa0ZVbphdjV23%2FcxbZ6x38KwuwFIn7YlqESntIt1nqEHcwSKE%2FtsPhG4ViLDX7ERI06zrlBKXN6ICiz6XDK7YtCFx%2FpxCz5k7jpN4IDFNnyAhnZvOMh%20W4uwNBOAeOFelzsllxubNUOTmCOAs6MfdCCwMH6BvXKExTNI%20Pl2EEzRujLOsQWuTnue3DUe0rQDk5%2F0CKPFqMPkHbs6HdRfuB8F5Jz=	2026-07-02 14:53:50.850107	Status not available on official portal
53	MEGHALAYA DAIRY DEVELOPMENT SCHEME	The Meghalaya Dairy Farming Development Scheme is a component under the Chief Minister’s CM-ELEVATE Program launched by the Government of Meghalaya. It aims to employ, engage, and empower the youth and rural communities by promoting Dairy related entrepreneurship through easy access to credit and subsidies.	Online Submission:\nApply via Meghalaya One  Portal with all supporting documents and DPR (if requested).\nScreening:\nDistrict and State committees shall verify and shortlist applications. The committees can also conduct physical background verification for shortlisted candidates if required\nInterview & Inspection:\nVirtual pitch, physical interview and site inspection by Department and bank teams shall be done as and when required.\nFinal Approval:\nState Sanction Committee issues approval letters.	\N	\N	https://meghalayaone.gov.in/meghalaya-one/view-detail?U2FsdGVkX1%2FW2utMkV67tQvXsVmfOmYZHpV8U%2FejbYc5dg8P9Ct%2FEgEx%2FHKnz0byJa4A4NFmK0pqUCrq1Fc7mqeXMK3gR6Dfp75PkUCfqW%209Jn8hyxhS6C%2FG%20zIWltyP3vx%2FAX1O1GsQU4VH7objV%20qX44lq8zIXkl6y%20WfaawjMAfDijcSQIhb1kj4a2Sm9Ra%204cJad0ZcmDcn90kmiGP2fD0E52B%2FzWCKmjTinqwrLf11wLDdUGSEpjEEkrQu8=	2026-07-02 14:50:20.625662	Status not available on official portal
52	MEGHALAYA ANY BUSINESS VENTURE SCHEME	The Meghalaya Any Business Ventures Scheme is a component under the Chief Minister’s CM-ELEVATE Program launched by the Government of Meghalaya. It aims to provide financial aid to 50 entrepreneurs from across the state to set up their business ventures in the state.	Screening:\nDistrict and State committees shall verify and shortlist applications. The committees can also conduct physical background verification for shortlisted candidates if required\nFinal Approval:\nState Sanction Committee issues approval letters.\nOnline Submission:\nApply via Meghalaya One  Portal with all supporting documents and DPR (if requested).\nInterview & Inspection:\nVirtual pitch, physical interview and site inspection by Department and bank teams shall be done as and when required.	\N	\N	https://meghalayaone.gov.in/meghalaya-one/view-detail?U2FsdGVkX18iYNKCVCghl0lwlZo95aHROIRvrDVUgstjlxc%20NxV6R1zLq544oeBcssnM2KvQQT851hjyVVLErb7Grc2PRzm5n4s5m83T2qaOwv8RK3gc0oFvO5S04UE0zvGe9Yqq%20JxJGJC42YN67QsHNdCxLvuSafmscpMPxHeZnCFCGbvnXxClAUzu6js3Z10imhcoGxqmBBYaVOvqHmKgiyKhfAyERRF2a8v5cKwjogNc2YAuf0BqKyPrJbcj=	2026-07-03 19:08:38.761844	Status not available on official portal
50	FOCUS SCHEME	FOCUS (Farmerâ€™s Collectivization for Upscaling Production and Marketing Systems) is one of the flagship schemes of Government of Meghalaya. An annual cash benefit of Rs. 50,000 to Rs. 1,00,000 to be provided to the Agri and Agri allied PGs. PG size may vary from 10 to 20 members. The benefit amount will be credited to the PG bank account through Direct Benefit Transfer (DBT).	V L F/ NGO\nDistrict Level Committee (DLC)	\N	\N	https://meghalayaone.gov.in/meghalaya-one/view-detail?U2FsdGVkX1%2FTyAV5SXnJtQCrn%2FW4rsJF4JMSt%20J3qhQTIfjKa41YRRpII8rZw4XihzwjAe1jyMZraqnHaXfEsDMoN9eyywvvyD2HXoWJl1LlK6SdorMg5JlGS6nUzdTpMYn75h3C7kAcnpVwl3sERugrDw9BRRdzyM9mcbaLDMSwTHVwp0LgLgK2S3beDhjIHH1UlN80rXmhO2SzXOCebi7WcFUTfLcQA94GfD3Jl05LkN1hm4BDKu9lNZrPl1m1=	2026-07-01 14:51:47.518878	open
54	MEGHALAYA GOAT FARMING SCHEME	The Meghalaya Goat Farming Development Scheme is a component under the Chief Minister’s CM-ELEVATE Program launched by the Government of Meghalaya. It aims to employ, engage, and empower the youth and rural communities by promoting goat farming entrepreneurship through easy access to credit and subsidies.	Online Submission:\nApply via Meghalaya One  Portal with all supporting documents and DPR (if requested).\nScreening:\nDistrict and State committees shall verify and shortlist applications. The committees can also conduct physical background verification for shortlisted candidates if required\nInterview & Inspection:\nVirtual pitch, physical interview and site inspection by Department and bank teams shall be done as and when required.\nFinal Approval:\nState Sanction Committee issues approval letters.	\N	\N	https://meghalayaone.gov.in/meghalaya-one/view-detail?U2FsdGVkX19dInhjQOjdcRThybu3L5a6Q3NeDqZyDTLiVbIzE%2F6b4Q%2F24bBt%2F4PZcW3wubEEAb2vp9e5BkX8GvHGZjQ88ooXgsgTkjaEau%2FQjpPLH9d3i1X0%20E9%209A8bL7RhrbAwkcj47NxJmo%20Q36BKcUF8wzR82iXkHEzWX%20EdIiKyzGIHTm9LBiBDBn823Wptb3SElFNTRejTsCsG4wpfndbY%20qLJFjTFJQ5E3MhnjOnriv0IIKTC6CDwQpfy=	2026-07-02 14:51:44.431099	Status not available on official portal
55	MEGHALAYA PIGGERY DEVELOPMENT SCHEME	The Meghalaya Piggery Development Scheme is a component under the Chief Minister’s CM-ELEVATE Program launched by the Government of Meghalaya. It aims to employ, engage, and empower the youth and rural communities by promoting piggery entrepreneurship through easy access to credit and subsidies.	Online Submission\n: Apply via Meghalaya One  Portal with all supporting documents and DPR (if requested).\nInterview & Inspection\n: Virtual pitch, physical interview and site inspection by Department and bank teams shall be done.\nScreening\n: District and State committees shall verify and shortlist applications.\nFinal Approval\n: State Sanction Committee issues approval letters.	\N	\N	https://meghalayaone.gov.in/meghalaya-one/view-detail?U2FsdGVkX1%20GbM0tC%2FZQjXlQupm%20biMhx2sdYNy9IzbL2s1xxnOnRg4E1W%209bPFSqpqfYd2LMqzqQEFaLpZn32Ux1oAWvUb9J068Lzrt2kitdbAN%2Fmt7HeG3MvTV14lcdFs7YmrhcJWjGtsNGuvCBuIhYagrmhY1LlSjdf9uevcdkd0gBgVX84QZVqOsgCrU01D6lY67YUkrxeKgcRO9%20l5N%20DXvWAxo3g8ypv8Hm3QnVfR5ZR%20pl2%2FnNT0mvIad=	2026-07-02 14:52:26.401299	Status not available on official portal
56	MEGHALAYA POULTRY FARMING SCHEME	The Meghalaya Poultry Farming Scheme is a component under the Chief Minister’s CM-ELEVATE Program launched by the Government of Meghalaya. It aims to employ, engage, and empower the youth and rural communities by promoting poultry entrepreneurship through easy access to credit and subsidies.	Online Submission:\nApply via Meghalaya One  Portal with all supporting documents and DPR (if requested).\nScreening:\nDistrict and State committees shall verify and shortlist applications. The committees can also conduct physical background verification for shortlisted candidates if required\nFinal Approval:\nState Sanction Committee issues approval letters.\nInterview & Inspection:\nVirtual pitch, physical interview and site inspection by Department and bank teams shall be done as and when required.	\N	\N	https://meghalayaone.gov.in/meghalaya-one/view-detail?U2FsdGVkX1%2FxotCE4rYB%2FFy0wCUUFevMT07pKK0q16z7PmUfsthRVAzgZVj%2FBDJkl3Yqr9KLUYOMliN%20Drl9tqz8NtWcpO0jW9ffcO5uPuFm5kzu11pgBwiv4WY%2F81BJdRcOm7myLYp5cwNRD5FtBuq48SzwyIGSjuEmSjIhLtuf8p6BODAcrQGK%20kwvGa4qTPu8UkMx%2F7xGU3sTg9zhOQFrTS1Lhz4b0SFI1OLllTLgo7JBSd7qOF8NrUvyWLcr=	2026-07-02 14:53:08.624357	Status not available on official portal
58	PRIME SMALL ENTERPRISE EMPOWERMENT AND DEVELOPMENT(SEED) SCHEME	The SEED scheme, under the Chief Minister’s ELEVATE Program, aims to empower youth and promote inclusive entrepreneurship in Meghalaya by providing financial support for setting up or expanding small business ventures across the state. It targets the unorganized sector and underserved business activities that contribute significantly to the local economy but have historically lacked institutional support.	Online Submission:\nApply via Meghalaya One  Portal with all supporting documents and DPR (if requested).\nScreening:\nDistrict and State committees shall verify and shortlist applications. The committees can also conduct physical background verification for shortlisted candidates if required\nFinal Approval:\nState Sanction Committee issues approval letters.\nInterview & Inspection:\nVirtual pitch, physical interview and site inspection by Department and bank teams shall be done as and when required.	\N	\N	https://meghalayaone.gov.in/meghalaya-one/view-detail?U2FsdGVkX19mH7XBzcXDj%2Ft0%2FmXQyoeNpd0uCZP9IS6cDk0%20oYYDxU1DG3bgm1eUYg%2FEJK34whoMLNanVyeIBTcWGHPO7aGgGUzIwtx4aNmz8Nsn3zDX%201qi3S71pCzDR3biWlgclnJJq%2Fb%2FRXcXCcGOcDjumLe4UmgFzQ2jwtZh%20sT1CxQi%2F2%2FZ9KDJ19P0wbatirVRzzq18F6MVwbYuOrzL%2FeNMw6AktjR1WWrBY5Rost5vnNqdehCWEujzo%20Y=	2026-07-02 14:54:33.860631	Status not available on official portal
59	PRIME TOURISM VEHICLE SCHEME	The PRIME Tourism Vehicle Scheme, under the Chief Minister’s CM-ELEVATE Program by the Planning, Investment Promotion & Sustainable Development Department, aims to boost Meghalaya’s tourism by providing 50% financial aid for purchasing adventure-tourism vehicles. Implemented by the Tourism Department, it offers easy credit through partner banks, training for operators, and government-funded GPS and branding support, enabling entrepreneurs and entities to enhance tourist transport and promote economic growth.	Online Submission:\nApply via Meghalaya One  Portal with all supporting documents and DPR (if requested).\nScreening:\nDistrict and State committees shall verify and shortlist applications. The committees can also conduct physical background verification for shortlisted candidates if required\nInterview & Inspection:\nVirtual pitch, physical interview and site inspection by Department and bank teams shall be done as and when required.\nFinal Approval:\nState Sanction Committee issues approval letters.	\N	\N	https://meghalayaone.gov.in/meghalaya-one/view-detail?U2FsdGVkX19V%20yD6Ol2m0oOAUjJuW96pd5nFtaIcIPDQi6LJLGxRnRbmQeaJm9du0kKTZufv2AM%20LSAzA%20Eco14mTJ91%2F%2FPyGlzd1lj5hnUyYLp0HC%208MZolDy4HJR6sUflXOJEPbISXaGhT5Zync8k%209KfVLGw%2FtI0EF5IqifexVEcheLy%20QHFp%2FftQhrCVjEv6qJIMSGr1KIpEiQ%20yHZoFZ%2FHXxRJqryQkvgFxtNbn40nI4XaJ5a8%20UTVOwh6I=	2026-07-02 14:55:31.142142	Status not available on official portal
48	CHIEF MINISTERS GREEN TAXI SCHEME	Part of the CM-ELEVATE Program by the Planning, Investment Promotion & Sustainable Development Department, Government of Meghalaya, the scheme promotes clean mobility and green entrepreneurship in the Greater Shillong Planning Area (GSPA). It targets pollution reduction, electric vehicle adoption, and support for individuals, SHGs, and cooperatives.\nEntrepreneurs receive up to 50% support on the vehicle's on-road cost (5% by entrepreneur, 45% by Government), including EMI subsidy, branding support, and scrappage incentives. Implemented by the Urban Affairs Department, with loans facilitated by partner banks, the scheme covers select Tata EV models with a ₹5 lakh subsidy cap. It aims to improve air quality, support sustainable transport, and contribute to Meghalaya’s $16 billion economy vision by 2032.	Online Submission:\nApply via Meghalaya One  Portal with all supporting documents and DPR (if requested).\nScreening:\nDistrict and State committees shall verify and shortlist applications.\nInterview & Inspection:\nVirtual pitch, physical interview and site inspection by Department and bank teams shall be done.\nFinal Approval:\nState Sanction Committee issues approval letters.	\N	\N	https://meghalayaone.gov.in/meghalaya-one/view-detail?U2FsdGVkX1%2FAA88SgXo9eeFP4ahgQqkSGJghMJrj1DEGytbjnA5paU5xoiWtfGBfCfeFGA%2FJcbrX31Yf2y%2F6pd2QMZ3puZoC%20l0oqFvX%200ex62URspAqabD8eBEH9x9%2F%2FZd1PMUH6Dte4f2%2FcACMRLFQlojpdGaeEogLmtbQ35eV4juLdth5CSn4AGOKPgrSahkiwWfZC8sr7MzpR%20Gre%2FAx3G6tNnJY1Ox7AxLIcsARGIEHQcfzEKvawZIpag%2FX=	2026-07-01 14:50:54.982984	Status not available on official portal
51	MEGHALAYA AGRICULTURE WAREHOUSE SCHEME	The Meghalaya Agriculture Warehouse Scheme, under the Chief Minister’s CM-ELEVATE Program by the Planning, Investment Promotion & Sustainable Development Department, Government of Meghalaya, focuses on enhancing agricultural infrastructure through the establishment of warehouses across the state. It aims to reduce post-harvest losses, stabilize market prices, and improve farmer incomes.\n\nThe scheme offers easy credit access via partner banks and substantial government subsidies to ease entrepreneurs’ financial burden. Implemented by the Meghalaya Basin Management Agency (MBMA), it supports individuals and registered entities in creating weatherproof storage for agricultural produce, enabling value addition, market linkages, and long-term storage for the farming community.	Online Submission:\nApply via the CM-ELEVATE Portal with all required documents as per eligibility criteria\nScreening:\nApplications will be verified based on submitted documents by the Meghalaya Basin Management Agency (MBMA). Shortlisting will be done after document verification\nInterview & Inspection:\nShortlisted applicants may undergo personal interviews conducted by the State Level Evaluation Committee and a physical inspection of the proposed land to verify ownership lease\nFinal Approval:\nThe State Level Evaluation Committee, headed by the CEO/ED of MBMA with banking partners as members, will evaluate and recommend applications for sanction.	\N	\N	https://meghalayaone.gov.in/meghalaya-one/view-detail?U2FsdGVkX1%2FXZjscdgAptXmi4J3mBdBd8%200r%2FvTaYSstgZS3c33QPkNKD%2Fhm9Jb%2Ff1QAYIANE0%2FdvsVZrhW6YUMDOoLBm9hEUge2Z07CkWY8rQ8a6Nt%2F0BAsaEkYgZfWvsTAUZsc0LfTv6OwtouF6P3YIYKC9mwyu0RHjNt2vSxZNTEAnRxHMgEbpyqL8U67P4YEzy7oJkYGzp3hdx49DB7Z0EwmWTqcDlbn1BpfdBuANz0FZ7oaW88ljgCX5m%2F8=	2026-07-01 14:52:29.285611	Status not available on official portal
49	CHIEF MINISTER'S REGIONAL TRANSPORT SCHEME	The Chief Minister’s Regional Transport Scheme, launched under the Chief Minister’s CM-ELEVATE Program by the Transport Department, Government of Meghalaya, is a flagship initiative to strengthen regional connectivity across the state. The scheme aims to establish a reliable bus network linking Block Headquarters with District Headquarters to ensure equitable access to governance, healthcare, education, and economic opportunities.	Online Submission:\nApplications must be submitted online through the Meghalaya One portal, along with all required documents.\nScreening:\nApplications will be verified and shortlisted based on eligibility and document verification by the State Level Screening Committee (SLSC), which includes representatives from the Transport Department, Meghalaya Transport Corporation, District/Block officials, and partner banks.\nInterview & Evaluation:\nShortlisted applicants may be called for interviews. Assessment will include interpersonal skills, prior experience, business acumen, creditworthiness, willingness to operate required routes, and knowledge of transport operations.\nFinal Approval:\nApprovals are granted after evaluation. The scheme mentions approval through the State Level Screening Committee rather than a separate “State Sanction Committee.” Approval letters are issued to selected entrepreneurs.	\N	\N	https://meghalayaone.gov.in/meghalaya-one/view-detail?U2FsdGVkX1%2FKXPK0ySfxZLNybMp66MGInFYWcLW0GgZD8KOsEvm%2FV8LH8WLKzYPyf%2Ff7qh%20WyGLlm0rREkALUE2cuH%201yAmKtw5PNKIhhDgUuOYxKVpnxb6Geh2asq2SIGQd2TztFORWluNNKHN1ZE5UO6LxLjIQee8shxQlixMVYoTzMTTaXeMBxbo6CUOHaMiWcPafVy%20GN1DFB9jFIz4EoBgvGnF0Ir3nCErxb7GDIZlLxaOcYvh7PGOaZJvG=	2026-07-01 14:51:37.111053	Status not available on official portal
\.


--
-- Data for Name: scrape_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.scrape_log (id, scheme_id, scraped_at, status, changes_found) FROM stdin;
45	47	2026-07-01 14:50:13.264433	success	initial scrape
46	48	2026-07-01 14:50:54.982984	success	initial scrape
47	49	2026-07-01 14:51:37.111053	success	initial scrape
48	50	2026-07-01 14:51:47.518878	success	initial scrape
49	51	2026-07-01 14:52:29.285611	success	initial scrape
50	52	2026-07-01 14:52:41.651543	success	initial scrape
51	53	2026-07-02 14:50:20.625662	success	initial scrape
52	54	2026-07-02 14:51:44.431099	success	initial scrape
53	55	2026-07-02 14:52:26.401299	success	initial scrape
54	56	2026-07-02 14:53:08.624357	success	initial scrape
55	57	2026-07-02 14:53:50.850107	success	initial scrape
56	58	2026-07-02 14:54:33.860631	success	initial scrape
57	59	2026-07-02 14:55:31.142142	success	initial scrape
58	47	2026-07-03 17:30:08.675054	checked	no changes
59	48	2026-07-03 17:30:50.623623	checked	no changes
60	49	2026-07-03 17:31:32.385842	checked	no changes
61	50	2026-07-03 17:31:42.780308	checked	no changes
62	51	2026-07-03 17:32:24.682504	checked	no changes
63	52	2026-07-03 17:32:34.452179	checked	no changes
64	53	2026-07-03 17:37:08.466622	checked	no changes
65	54	2026-07-03 17:37:51.24314	checked	no changes
66	55	2026-07-03 17:38:32.107485	checked	no changes
67	56	2026-07-03 17:39:13.291716	checked	no changes
68	57	2026-07-03 17:39:54.525366	checked	no changes
69	58	2026-07-03 17:40:35.688785	checked	no changes
70	59	2026-07-03 17:41:16.950041	checked	no changes
71	47	2026-07-03 19:05:41.033604	checked	no changes
72	48	2026-07-03 19:06:22.519185	checked	no changes
73	49	2026-07-03 19:07:03.998336	checked	no changes
74	50	2026-07-03 19:07:13.89322	checked	no changes
75	51	2026-07-03 19:07:57.139731	checked	no changes
76	52	2026-07-03 19:08:38.761844	updated	Description changed, Eligibility changed, Required Documents changed, Benefits changed, Application Process changed, Application Status changed
77	53	2026-07-03 19:09:20.244248	checked	no changes
78	54	2026-07-03 19:10:01.716885	checked	no changes
79	55	2026-07-03 19:16:13.645284	checked	no changes
80	56	2026-07-03 19:16:55.953218	checked	no changes
81	57	2026-07-03 19:17:37.497088	checked	no changes
82	58	2026-07-03 19:18:18.959595	checked	no changes
83	59	2026-07-03 19:19:00.394946	checked	no changes
84	47	2026-07-18 17:03:31.415056	checked	no changes
85	48	2026-07-18 17:04:14.222395	checked	no changes
86	49	2026-07-18 17:04:55.872969	checked	no changes
87	50	2026-07-18 17:05:05.922098	checked	no changes
88	51	2026-07-18 17:05:47.577416	checked	no changes
89	52	2026-07-18 17:06:29.279473	checked	no changes
90	53	2026-07-18 17:07:11.044668	checked	no changes
91	54	2026-07-18 17:07:52.748471	checked	no changes
92	55	2026-07-18 17:08:34.522124	checked	no changes
93	56	2026-07-18 17:09:16.579605	checked	no changes
94	57	2026-07-18 17:10:43.858653	checked	no changes
95	58	2026-07-18 17:11:26.375336	checked	no changes
96	59	2026-07-18 17:12:09.632451	checked	no changes
\.


--
-- Name: scheme_benefits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.scheme_benefits_id_seq', 54, true);


--
-- Name: scheme_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.scheme_documents_id_seq', 54, true);


--
-- Name: scheme_eligibility_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.scheme_eligibility_id_seq', 57, true);


--
-- Name: scheme_faqs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.scheme_faqs_id_seq', 1, false);


--
-- Name: schemes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.schemes_id_seq', 59, true);


--
-- Name: scrape_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.scrape_log_id_seq', 96, true);


--
-- Name: scheme_benefits scheme_benefits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheme_benefits
    ADD CONSTRAINT scheme_benefits_pkey PRIMARY KEY (id);


--
-- Name: scheme_documents scheme_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheme_documents
    ADD CONSTRAINT scheme_documents_pkey PRIMARY KEY (id);


--
-- Name: scheme_eligibility scheme_eligibility_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheme_eligibility
    ADD CONSTRAINT scheme_eligibility_pkey PRIMARY KEY (id);


--
-- Name: scheme_faqs scheme_faqs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheme_faqs
    ADD CONSTRAINT scheme_faqs_pkey PRIMARY KEY (id);


--
-- Name: schemes schemes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schemes
    ADD CONSTRAINT schemes_pkey PRIMARY KEY (id);


--
-- Name: scrape_log scrape_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scrape_log
    ADD CONSTRAINT scrape_log_pkey PRIMARY KEY (id);


--
-- Name: scheme_benefits scheme_benefits_scheme_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheme_benefits
    ADD CONSTRAINT scheme_benefits_scheme_id_fkey FOREIGN KEY (scheme_id) REFERENCES public.schemes(id) ON DELETE CASCADE;


--
-- Name: scheme_documents scheme_documents_scheme_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheme_documents
    ADD CONSTRAINT scheme_documents_scheme_id_fkey FOREIGN KEY (scheme_id) REFERENCES public.schemes(id) ON DELETE CASCADE;


--
-- Name: scheme_eligibility scheme_eligibility_scheme_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheme_eligibility
    ADD CONSTRAINT scheme_eligibility_scheme_id_fkey FOREIGN KEY (scheme_id) REFERENCES public.schemes(id) ON DELETE CASCADE;


--
-- Name: scheme_faqs scheme_faqs_scheme_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheme_faqs
    ADD CONSTRAINT scheme_faqs_scheme_id_fkey FOREIGN KEY (scheme_id) REFERENCES public.schemes(id) ON DELETE CASCADE;


--
-- Name: scrape_log scrape_log_scheme_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scrape_log
    ADD CONSTRAINT scrape_log_scheme_id_fkey FOREIGN KEY (scheme_id) REFERENCES public.schemes(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict mL45HrZxFSnilFbfNPyfGMcvq1DRuJXsvIFfVBLVOfjyPg5Xd010VJ2yeTIaevF

